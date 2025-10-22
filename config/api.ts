// API Configuration
const API_BASE_URL =
  (import.meta.env.VITE_BACKEND_URL ?? window.location.origin) +
  (import.meta.env.VITE_API_BASE_URL ?? '/api');

export const API_ENDPOINTS = {
  health: `${API_BASE_URL}/health`,
  status: `${API_BASE_URL}/status`,
  stats: `${API_BASE_URL}/stats`,
  activity: `${API_BASE_URL}/activity`,
  config: `${API_BASE_URL}/config`,
  env: `${API_BASE_URL}/env`,
  workflowStatus: `${API_BASE_URL}/workflow-status`,
  startAutomation: `${API_BASE_URL}/start-automation`,
  stopAutomation: `${API_BASE_URL}/stop-automation`,
  resetStats: `${API_BASE_URL}/reset-stats`,
  performanceData: `${API_BASE_URL}/performance-data`,
  performanceWeekly: `${API_BASE_URL}/performance/weekly`,
  performanceRealtime: `${API_BASE_URL}/performance/realtime`,
  performanceAgents: `${API_BASE_URL}/performance/agents`,
  currentAgents: `${API_BASE_URL}/current-agents`
};

const REQUEST_TIMEOUT = 10000;
const MAX_RETRIES = 3;

const timeout = (ms: number): Promise<never> =>
  new Promise((_, reject) =>
    setTimeout(() => reject(new Error('Request timeout')), ms)
  );

const fetchWithRetry = async (
  url: string,
  options: RequestInit = {},
  retries = MAX_RETRIES
): Promise<Response> => {
  try {
    const response = await Promise.race([
      fetch(url, options),
      timeout(REQUEST_TIMEOUT)
    ]);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response;
  } catch (error) {
    if (retries > 0) {
      await new Promise(res => setTimeout(res, 1000));
      return fetchWithRetry(url, options, retries - 1);
    }
    throw error;
  }
};

export const api = {
  async getHealth() {
    const res = await fetchWithRetry(API_ENDPOINTS.health);
    return res.json();
  },
  async getStatus() {
    const res = await fetchWithRetry(API_ENDPOINTS.status);
    return res.json();
  },
  async getStats() {
    const res = await fetchWithRetry(API_ENDPOINTS.stats);
    return res.json();
  },
  async getActivity() {
    const res = await fetchWithRetry(API_ENDPOINTS.activity);
    return res.json();
  },
  async getConfig() {
    const res = await fetchWithRetry(API_ENDPOINTS.config);
    return res.json();
  },
  async startAutomation(data: any) {
    const res = await fetchWithRetry(API_ENDPOINTS.startAutomation, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(data)
    });
    return res.json();
  },
  async stopAutomation() {
    const res = await fetchWithRetry(API_ENDPOINTS.stopAutomation, {method: 'POST'});
    return res.json();
  },
  async resetStats() {
    const res = await fetchWithRetry(API_ENDPOINTS.resetStats, {method: 'POST'});
    return res.json();
  },
  async getPerformanceData() {
    const res = await fetchWithRetry(API_ENDPOINTS.performanceData);
    return res.json();
  },
  async getWeeklyPerformance() {
    const res = await fetchWithRetry(API_ENDPOINTS.performanceWeekly);
    return res.json();
  },
  async getRealTimeMetrics() {
    const res = await fetchWithRetry(API_ENDPOINTS.performanceRealtime);
    return res.json();
  },
  async getAgentPerformance() {
    const res = await fetchWithRetry(API_ENDPOINTS.performanceAgents);
    return res.json();
  },
  async getCurrentAgents() {
    const res = await fetchWithRetry(API_ENDPOINTS.currentAgents);
    return res.json();
  }
};
