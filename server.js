const express = require('express');
const cors = require('cors');
const axios = require('axios');
const app = express();

// Enable CORS for your Flutter web app
app.use(cors({
  origin: '*', // In production, replace with your actual domain
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type']
}));

// NewsAPI configuration
const NEWS_API_KEY = '075838cfc27f4306b755bd8a3e07ffc1';
const NEWS_API_BASE_URL = 'https://newsapi.org/v2';

// Proxy endpoint for startup news
app.get('/api/startup-news', async (req, res) => {
  try {
    const response = await axios.get(`${NEWS_API_BASE_URL}/everything`, {
      params: {
        q: 'startup',
        language: 'en',
        sortBy: 'publishedAt',
        apiKey: NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching startup news:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

// Proxy endpoint for tech news
app.get('/api/tech-news', async (req, res) => {
  try {
    const response = await axios.get(`${NEWS_API_BASE_URL}/top-headlines`, {
      params: {
        category: 'technology',
        language: 'en',
        apiKey: NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching tech news:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

// Proxy endpoint for market trends
app.get('/api/market-trends', async (req, res) => {
  try {
    const response = await axios.get(`${NEWS_API_BASE_URL}/everything`, {
      params: {
        q: 'stock market technology',
        language: 'en',
        sortBy: 'publishedAt',
        apiKey: NEWS_API_KEY
      }
    });
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching market trends:', error);
    res.status(500).json({ error: 'Failed to fetch market trends' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 