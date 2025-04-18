<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- 根模板 -->
  <xsl:template match="/">
    <html data-theme="light" lang="zh-CN">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><xsl:value-of select="rss/channel/title"/></title>
        
        <!-- 动态主题CSS -->
        <style>
          :root {
            --bg-primary: #ffffff;
            --bg-secondary: #f8f9fa;
            --text-primary: #212529;
            --text-secondary: #495057;
            --link-color: #0d6efd;
            --border-color: #dee2e6;
            --transition-speed: 0.3s;
          }
          
          [data-theme="dark"] {
            --bg-primary: #121212;
            --bg-secondary: #1e1e1e;
            --text-primary: #e0e0e0;
            --text-secondary: #9e9e9e;
            --link-color: #4dabf7;
            --border-color: #333333;
          }

          body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            transition: 
              background-color var(--transition-speed),
              color var(--transition-speed);
          }

          .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
          }

          header {
            margin-bottom: 2rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
          }

          h1 {
            color: var(--text-primary);
            margin: 0;
            font-size: 2rem;
          }

          .item {
            background: var(--bg-secondary);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border-color);
            transition: 
              background-color var(--transition-speed),
              border-color var(--transition-speed);
          }

          .item h2 {
            margin-top: 0;
            font-size: 1.5rem;
          }

          .item a {
            color: var(--link-color);
            text-decoration: none;
          }

          .item a:hover {
            text-decoration: underline;
          }

          .meta {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin: 0.5rem 0;
          }

          .theme-toggle {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            border-radius: 50%;
            width: 3rem;
            height: 3rem;
            font-size: 1.2rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition-speed);
          }

          .theme-toggle:hover {
            transform: scale(1.1);
          }
        </style>
      </head>

      <body>
        <div class="container">
          <header>
            <h1><xsl:value-of select="rss/channel/title"/></h1>
            <p><xsl:value-of select="rss/channel/description"/></p>
          </header>

          <main>
            <xsl:apply-templates select="rss/channel/item"/>
          </main>
        </div>

        <button class="theme-toggle" onclick="toggleTheme()">🌓</button>

        <!-- 主题切换脚本 -->
        <script>
          const htmlEl = document.documentElement;
          const STORAGE_KEY = 'rss-theme-preference';
          const THEME_LIGHT = 'light';
          const THEME_DARK = 'dark';

          // 初始化主题
          function initTheme() {
            const savedTheme = localStorage.getItem(STORAGE_KEY);
            const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            
            // 优先级: 用户保存 > 系统偏好 > 默认light
            const initialTheme = savedTheme || (systemPrefersDark ? THEME_DARK : THEME_LIGHT);
            htmlEl.setAttribute('data-theme', initialTheme);
            
            // 监听系统主题变化
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
              if (!localStorage.getItem(STORAGE_KEY)) {
                htmlEl.setAttribute('data-theme', e.matches ? THEME_DARK : THEME_LIGHT);
              }
            });
          }

          // 切换主题
          function toggleTheme() {
            const currentTheme = htmlEl.getAttribute('data-theme');
            const newTheme = currentTheme === THEME_DARK ? THEME_LIGHT : THEME_DARK;
            
            htmlEl.setAttribute('data-theme', newTheme);
            localStorage.setItem(STORAGE_KEY, newTheme);
          }

          // 初始化
          document.addEventListener('DOMContentLoaded', initTheme);
        </script>
      </body>
    </html>
  </xsl:template>

  <!-- 条目模板 -->
  <xsl:template match="item">
    <article class="item">
      <h2>
        <a href="{link}">
          <xsl:value-of select="title"/>
        </a>
      </h2>
      <div class="meta">
        <time><xsl:value-of select="pubDate"/></time>
        <xsl:if test="author"> • <xsl:value-of select="author"/></xsl:if>
      </div>
      <div class="description">
        <xsl:value-of select="description" disable-output-escaping="yes"/>
      </div>
    </article>
  </xsl:template>
</xsl:stylesheet>
