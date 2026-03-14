/**
 * OpenClaw 天气查询 Skill 示例
 *
 * 这是一个实用的天气查询技能，展示如何创建一个完整的 Skill。
 *
 * @module weather-skill
 * @version 1.0.0
 */

module.exports = {
  // Skill 元数据
  name: 'weather-query',
  version: '1.0.0',
  description: '天气查询助手，支持城市天气查询和预报',
  author: 'OpenClaw Tutorial',
  category: 'utility',
  tags: ['weather', 'query', 'utility'],

  // Skill 配置
  config: {
    enabled: true,
    options: {
      // 默认城市
      defaultCity: '北京',
      // API密钥（需要在 openclaw.json 中配置）
      apiKey: process.env.WEATHER_API_KEY || '',
      // API端点（示例）
      apiEndpoint: 'https://api.weatherapi.com/v1'
    }
  },

  /**
   * Skill 初始化
   */
  async init(context) {
    this.logger = context.logger;
    this.config = { ...this.config, ...context.config };
    this.logger.info('天气查询 Skill 初始化成功');
  },

  /**
   * 处理用户消息
   */
  async handleMessage(message, context) {
    // 解析城市名称
    const city = this.extractCity(message) || this.config.options.defaultCity;

    try {
      // 获取天气信息
      const weather = await this.getWeather(city);

      // 格式化响应
      return {
        success: true,
        message: this.formatWeather(weather),
        data: weather
      };
    } catch (error) {
      this.logger.error('获取天气失败:', error);
      return {
        success: false,
        message: `获取${city}天气失败：${error.message}`
      };
    }
  },

  /**
   * 提取城市名称
   * @param {string} message - 用户消息
   * @returns {string|null} 城市名称
   */
  extractCity(message) {
    // 匹配"天气"关键词后面的城市名
    const patterns = [
      /(?:查询|查看|获取)?(?:今天|明天)?(.{2,4})的天气/,
      /(.{2,4})(?:市)?天气/,
      /weather\s+(?:in\s+)?(.{2,10})/i
    ];

    for (const pattern of patterns) {
      const match = message.match(pattern);
      if (match && match[1]) {
        return match[1].trim();
      }
    }

    return null;
  },

  /**
   * 获取天气信息
   * @param {string} city - 城市名称
   * @returns {Promise<Object>} 天气数据
   */
  async getWeather(city) {
    // 检查API密钥
    if (!this.config.options.apiKey) {
      // 返回模拟数据（用于演示）
      return this.getMockWeather(city);
    }

    try {
      // 调用真实API（示例）
      // const url = `${this.config.options.apiEndpoint}/current.json?key=${this.config.options.apiKey}&q=${encodeURIComponent(city)}`;
      // const response = await fetch(url);
      // const data = await response.json();
      // return this.parseWeatherData(data);

      // 这里使用模拟数据
      return this.getMockWeather(city);
    } catch (error) {
      throw new Error(`API调用失败: ${error.message}`);
    }
  },

  /**
   * 获取模拟天气数据
   * @param {string} city - 城市名称
   * @returns {Object} 模拟天气数据
   */
  getMockWeather(city) {
    const conditions = ['晴', '多云', '阴', '小雨', '大雨', '雪'];
    const randomCondition = conditions[Math.floor(Math.random() * conditions.length)];
    const randomTemp = Math.floor(Math.random() * 30) + 5; // 5-35度

    return {
      city: city,
      condition: randomCondition,
      temperature: randomTemp,
      humidity: Math.floor(Math.random() * 50) + 30, // 30-80%
      wind: Math.floor(Math.random() * 10) + 1, // 1-10级
      updateTime: new Date().toLocaleString('zh-CN')
    };
  },

  /**
   * 格式化天气信息
   * @param {Object} weather - 天气数据
   * @returns {string} 格式化的天气信息
   */
  formatWeather(weather) {
    return `📍 ${weather.city}天气

🌡️ 温度：${weather.temperature}°C
☁️ 天气：${weather.condition}
💧 湿度：${weather.humidity}%
💨 风力：${weather.wind}级

🕐 更新时间：${weather.updateTime}`;
  },

  /**
   * 解析API返回的天气数据
   * @param {Object} data - API返回数据
   * @returns {Object} 解析后的天气数据
   */
  parseWeatherData(data) {
    return {
      city: data.location.name,
      condition: data.current.condition.text,
      temperature: data.current.temp_c,
      humidity: data.current.humidity,
      wind: data.current.wind_kph,
      updateTime: new Date().toLocaleString('zh-CN')
    };
  },

  /**
   * Skill 帮助信息
   */
  getHelp() {
    return `天气查询助手使用指南：

📌 支持的查询方式：
• "北京今天天气怎么样？"
• "查询上海的天气"
• "明天深圳天气"
• "weather in Tokyo"

📌 返回信息：
• 当前温度
• 天气状况
• 湿度
• 风力等级
• 更���时间

📌 配置说明：
在 openclaw.json 中配置 API Key：
{
  "skills": {
    "weather-query": {
      "apiKey": "your-api-key-here"
    }
  }
}`;
  },

  /**
   * Skill 清理
   */
  async cleanup() {
    this.logger.info('天气查询 Skill 清理完成');
  }
};
