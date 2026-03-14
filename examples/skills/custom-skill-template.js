/**
 * OpenClaw 自定义 Skill 模板
 *
 * 这是一个完整的 Skill 开发模板，包含所有必要的生命周期钩子和最佳实践。
 *
 * @module custom-skill-template
 * @version 1.0.0
 */

module.exports = {
  // Skill 元数据
  name: 'my-custom-skill',
  version: '1.0.0',
  description: '我的自定义技能',
  author: 'Your Name',
  category: 'utility',

  // Skill 配置选项
  config: {
    // 默认配置
    enabled: true,
    // 可以在 openclaw.json 中覆盖这些配置
    options: {
      // 示例：API端点
      apiEndpoint: 'https://api.example.com',
      // 示例：超时设置
      timeout: 5000
    }
  },

  /**
   * Skill 初始化钩子
   * @param {Object} context - OpenClaw 上下文对象
   */
  async init(context) {
    this.logger = context.logger;
    this.config = context.config;
    this.logger.info('Skill 初始化成功');
  },

  /**
   * 处理消息钩子
   * @param {string} message - 用户消息
   * @param {Object} context - 消息上下文
   * @returns {Promise<Object>} 处理结果
   */
  async handleMessage(message, context) {
    this.logger.info('收到消息:', message);

    // 解析用户意图
    const intent = this.parseIntent(message);

    // 根据意图执行相应操作
    switch (intent.type) {
      case 'query':
        return await this.handleQuery(intent.params, context);
      case 'action':
        return await this.handleAction(intent.params, context);
      default:
        return {
          success: false,
          message: '抱歉，我不理解这个请求'
        };
    }
  },

  /**
   * 解析用户意图
   * @param {string} message - 用户消息
   * @returns {Object} 解析结果
   */
  parseIntent(message) {
    // 简单的关键词匹配
    if (message.includes('查询') || message.includes('搜索')) {
      return {
        type: 'query',
        params: { query: message.replace(/查询|搜索/g, '').trim() }
      };
    } else if (message.includes('执行') || message.includes('运行')) {
      return {
        type: 'action',
        params: { action: message.replace(/执行|运行/g, '').trim() }
      };
    }
    return { type: 'unknown' };
  },

  /**
   * 处理查询请求
   * @param {Object} params - 查询参数
   * @param {Object} context - 上下文
   * @returns {Promise<Object>} 查询结果
   */
  async handleQuery(params, context) {
    try {
      // 调用外部API或执行查询逻辑
      const result = await this.fetchData(params.query);

      return {
        success: true,
        data: result,
        message: `查询成功：${result}`
      };
    } catch (error) {
      this.logger.error('查询失败:', error);
      return {
        success: false,
        error: error.message,
        message: '查询失败，请稍后重试'
      };
    }
  },

  /**
   * 处理动作请求
   * @param {Object} params - 动作参数
   * @param {Object} context - 上下文
   * @returns {Promise<Object>} 执行结果
   */
  async handleAction(params, context) {
    try {
      // 执行动作
      const result = await this.executeAction(params.action);

      return {
        success: true,
        data: result,
        message: `执行成功：${result}`
      };
    } catch (error) {
      this.logger.error('执行失败:', error);
      return {
        success: false,
        error: error.message,
        message: '执行失败，请稍后重试'
      };
    }
  },

  /**
   * 获取数据（示例方法）
   * @param {string} query - 查询字符串
   * @returns {Promise<string>} 查询结果
   */
  async fetchData(query) {
    // 这里实现你的数据获取逻辑
    // 示例：调用API
    // const response = await fetch(`${this.config.options.apiEndpoint}/query?q=${encodeURIComponent(query)}`);
    // return await response.json();

    // 简单示例：返回查询内容
    return `查询"${query}"的结果`;
  },

  /**
   * 执行动作（示例方法）
   * @param {string} action - 动作描述
   * @returns {Promise<string>} 执行结果
   */
  async executeAction(action) {
    // 这里实现你的动作执行逻辑
    return `已执行动作：${action}`;
  },

  /**
   * Skill 清理钩子
   */
  async cleanup() {
    this.logger.info('Skill 清理完成');
  }
};
