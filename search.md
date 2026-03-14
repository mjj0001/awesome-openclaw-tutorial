---
layout: default
title: 搜索
---

<div class="search-container">
  <div class="search-box">
    <input type="text" id="search-input" placeholder="搜索教程内容..." autocomplete="off">
    <button id="search-button">🔍 搜索</button>
  </div>

  <div id="search-stats"></div>
  <div id="search-results"></div>
</div>

<style>
.search-container {
  max-width: 900px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.search-box {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  border-radius: 8px;
  overflow: hidden;
}

#search-input {
  flex: 1;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  border: 2px solid #0d7377;
  outline: none;
  transition: all 0.3s;
}

#search-input:focus {
  border-color: #0f3460;
  box-shadow: 0 0 0 3px rgba(13, 115, 119, 0.1);
}

#search-button {
  padding: 1rem 2rem;
  font-size: 1.1rem;
  background: linear-gradient(120deg, #0f3460, #0d7377);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: bold;
}

#search-button:hover {
  background: linear-gradient(120deg, #0d2a4f, #0a5f63);
  transform: scale(1.05);
}

#search-stats {
  margin-bottom: 1rem;
  color: #0d7377;
  font-weight: bold;
  font-size: 1.1rem;
}

#search-results {
  min-height: 200px;
}

.search-hint {
  text-align: center;
  color: #666;
  font-size: 1.2rem;
  padding: 4rem 0;
  background: #f8f9fa;
  border-radius: 8px;
  border: 2px dashed #ddd;
}

.search-result-item {
  padding: 1.5rem;
  margin-bottom: 1rem;
  background: #ffffff;
  border: 1px solid #e1e4e8;
  border-left: 4px solid #0d7377;
  border-radius: 8px;
  transition: all 0.3s;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.search-result-item:hover {
  background: #f6f8fa;
  border-left-color: #0f3460;
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.search-result-title {
  font-size: 1.3rem;
  font-weight: bold;
  margin-bottom: 0.75rem;
  line-height: 1.4;
}

.search-result-title a {
  color: #0f3460;
  text-decoration: none;
  transition: color 0.3s;
}

.search-result-title a:hover {
  color: #0d7377;
}

.search-result-excerpt {
  color: #586069;
  line-height: 1.6;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
}

.search-result-meta {
  font-size: 0.85rem;
  color: #0d7377;
  font-family: 'Courier New', monospace;
  opacity: 0.8;
}

.no-results {
  text-align: center;
  padding: 4rem 2rem;
  color: #666;
  background: #f8f9fa;
  border-radius: 8px;
  line-height: 1.8;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #0d7377;
  font-size: 1.2rem;
  font-weight: bold;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

mark {
  background-color: #fff3cd;
  padding: 0.1em 0.3em;
  border-radius: 3px;
  font-weight: bold;
  color: #856404;
}

@media (max-width: 768px) {
  .search-box {
    flex-direction: column;
  }

  #search-input {
    border-radius: 8px 8px 0 0;
  }

  #search-button {
    border-radius: 0 0 8px 8px;
  }

  .search-result-item {
    padding: 1rem;
  }

  .search-result-title {
    font-size: 1.1rem;
  }
}
</style>

<script>
(function() {
  let searchData = [];
  let isLoading = false;

  // 简单的中文分词（按字符和常见词组）
  function tokenize(text) {
    // 移除特殊字符，保留中文、英文、数字
    text = text.toLowerCase().replace(/[^\u4e00-\u9fa5a-z0-9\s]/g, ' ');

    // 英文按空格分词，中文按字符分词
    const tokens = [];
    const words = text.split(/\s+/);

    words.forEach(word => {
      if (/[\u4e00-\u9fa5]/.test(word)) {
        // 中文：添加单字和双字组合
        for (let i = 0; i < word.length; i++) {
          tokens.push(word[i]);
          if (i < word.length - 1) {
            tokens.push(word.substr(i, 2));
          }
        }
      } else if (word.length > 0) {
        // 英文：添加完整单词
        tokens.push(word);
      }
    });

    return [...new Set(tokens)]; // 去重
  }

  // 计算搜索相关性得分
  function calculateScore(doc, queryTokens) {
    let score = 0;
    const title = (doc.title || '').toLowerCase();
    const excerpt = (doc.excerpt || '').toLowerCase();
    const content = (doc.content || '').toLowerCase();
    const fullText = title + ' ' + excerpt + ' ' + content;

    queryTokens.forEach(token => {
      // 标题匹配（权重最高）
      if (title.includes(token)) {
        score += 10;
        if (title === token) score += 5; // 完全匹配
      }

      // 摘要匹配
      if (excerpt.includes(token)) {
        score += 3;
      }

      // 内容匹配
      if (content.includes(token)) {
        score += 1;
      }

      // 计算出现次数
      const count = (fullText.match(new RegExp(token, 'g')) || []).length;
      score += Math.min(count, 5); // 最多加5分
    });

    return score;
  }

  // 高亮关键词
  function highlightKeywords(text, queryTokens) {
    queryTokens.forEach(token => {
      const regex = new RegExp(`(${token.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
      text = text.replace(regex, '<mark>$1</mark>');
    });
    return text;
  }

  // 执行搜索
  function performSearch(query) {
    if (!query || query.trim() === '') {
      document.getElementById('search-results').innerHTML =
        '<p class="search-hint">💡 请输入搜索关键词</p>';
      document.getElementById('search-stats').innerHTML = '';
      return;
    }

    if (searchData.length === 0) {
      document.getElementById('search-results').innerHTML =
        '<p class="loading">⏳ 搜索索引加载中，请稍候...</p>';
      return;
    }

    document.getElementById('search-results').innerHTML =
      '<p class="loading">🔍 搜索中...</p>';

    // 分词
    const queryTokens = tokenize(query);
    console.log('搜索关键词:', queryTokens);

    // 计算每个文档的得分
    const results = searchData.map(doc => ({
      ...doc,
      score: calculateScore(doc, queryTokens)
    })).filter(doc => doc.score > 0);

    // 按得分排序
    results.sort((a, b) => b.score - a.score);

    // 显示结果
    if (results.length === 0) {
      document.getElementById('search-stats').innerHTML = '😕 没有找到匹配的内容';
      document.getElementById('search-results').innerHTML = `
        <div class="no-results">
          <p>没有找到包含 "<strong>${query}</strong>" 的内容</p>
          <p>💡 搜索技巧：</p>
          <ul style="text-align: left; display: inline-block;">
            <li>尝试使用更简短的关键词</li>
            <li>尝试同义词（如"安装"→"部署"）</li>
            <li>搜索英文关键词（如"API"、"Skills"）</li>
          </ul>
          <p style="margin-top: 1rem;">
            <a href="/">浏览教程目录</a> ·
            <a href="/appendix/A-command-reference.html">命令速查表</a>
          </p>
        </div>
      `;
      return;
    }

    // 显示统计信息
    document.getElementById('search-stats').innerHTML =
      `✨ 找到 ${results.length} 个相关结果`;

    // 显示结果（最多50个）
    let html = '';
    results.slice(0, 50).forEach((result, index) => {
      const title = highlightKeywords(result.title || '无标题', queryTokens);
      const excerpt = highlightKeywords(
        (result.excerpt || '').substring(0, 200) +
        ((result.excerpt || '').length > 200 ? '...' : ''),
        queryTokens
      );

      // 分类标签
      let categoryBadge = '';
      if (result.category) {
        const categoryMap = {
          'docs': '📚 文档',
          'appendix': '📖 附录',
          'examples': '💡 示例',
          'guide': '🎯 指南',
          'root': '🏠 首页'
        };
        const categoryName = categoryMap[result.category] || result.category;
        categoryBadge = `<span style="display: inline-block; padding: 0.2rem 0.5rem; background: #e1f5fe; color: #0277bd; border-radius: 3px; font-size: 0.85rem; margin-right: 0.5rem;">${categoryName}</span>`;
      }

      html += `
        <div class="search-result-item">
          <div class="search-result-title">
            <span style="color: #999; margin-right: 0.5rem;">${index + 1}.</span>
            ${categoryBadge}
            <a href="${result.url}">${title}</a>
          </div>
          ${excerpt ? `<div class="search-result-excerpt">${excerpt}</div>` : ''}
          <div class="search-result-meta">📄 ${result.url}</div>
        </div>
      `;
    });

    if (results.length > 50) {
      html += `<p style="text-align: center; color: #666; margin-top: 2rem;">显示前 50 个结果，共 ${results.length} 个</p>`;
    }

    document.getElementById('search-results').innerHTML = html;
  }

  // 加载搜索数据
  async function loadSearchData() {
    if (isLoading) return;
    isLoading = true;

    const searchFiles = [
      '/search-index-expanded.json',
      '/search-index.json',
      '/search.json'
    ];

    for (const file of searchFiles) {
      try {
        console.log(`🔍 尝试加载: ${file}`);
        const response = await fetch(file);

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        const data = await response.json();

        if (!data || data.length === 0) {
          throw new Error('搜索数据为空');
        }

        searchData = data;
        console.log(`✅ 成功加载搜索索引: ${file}`, `共 ${data.length} 个文档`);
        isLoading = false;
        return;

      } catch (error) {
        console.error(`❌ 加载失败 (${file}):`, error);
        continue;
      }
    }

    // 所有文件都加载失败
    console.error('❌ 所有搜索索引文件都加载失败');
    document.getElementById('search-results').innerHTML = `
      <div class="no-results">
        <p style="font-size: 1.2rem; margin-bottom: 1rem;">😕 搜索功能暂时不可用</p>
        <p>可能的原因：</p>
        <ul style="text-align: left; display: inline-block;">
          <li>网站正在构建中，请稍后再试</li>
          <li>网络连接问题</li>
          <li>浏览器缓存问题</li>
        </ul>
        <p style="margin-top: 1.5rem;">
          <button onclick="location.reload()" style="padding: 0.5rem 1rem; background: #0d7377; color: white; border: none; border-radius: 4px; cursor: pointer;">
            🔄 刷新页面
          </button>
        </p>
        <p style="margin-top: 1.5rem; font-size: 0.9rem; color: #999;">
          或者直接 <a href="/" style="color: #0d7377;">浏览教程目录</a>
        </p>
      </div>
    `;
    isLoading = false;
  }

  // 初始化
  document.addEventListener('DOMContentLoaded', function() {
    // 加载搜索数据
    loadSearchData();

    // 绑定搜索事件
    const searchInput = document.getElementById('search-input');
    const searchButton = document.getElementById('search-button');

    searchButton.addEventListener('click', function() {
      performSearch(searchInput.value);
    });

    searchInput.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        performSearch(searchInput.value);
      }
    });

    // 实时搜索（输入时自动搜索，带防抖）
    let searchTimeout;
    searchInput.addEventListener('input', function() {
      clearTimeout(searchTimeout);
      const query = this.value;

      if (query.length === 0) {
        document.getElementById('search-results').innerHTML =
          '<p class="search-hint">💡 请输入搜索关键词</p>';
        document.getElementById('search-stats').innerHTML = '';
        return;
      }

      if (query.length >= 2) {
        searchTimeout = setTimeout(() => performSearch(query), 300);
      }
    });

    // 检查URL参数
    const urlParams = new URLSearchParams(window.location.search);
    const queryParam = urlParams.get('q');
    if (queryParam) {
      searchInput.value = queryParam;
      performSearch(queryParam);
    }
  });
})();
</script>
