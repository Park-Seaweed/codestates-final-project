import axios from 'axios';

const articleApiInstance = axios.create({
  baseURL: process.env.REACT_APP_BACK_END_URL,
});

articleApiInstance.interceptors.request.use((config) => {
  const accessToken = localStorage.getItem('accessToken');
  if (accessToken) {
    config.headers['authorization'] = `${accessToken}`;
  }
  return config;
});

export const articleApi = {
  getArticles: () => {
    return articleApiInstance.get(`/articles`);
  },

  addArticles: (data) => {
    return articleApiInstance.post(`/articles`, data);
  },

  deleteArticles: (data) => {
    return articleApiInstance.delete(`/articles/${data}`);
  },

  updateArticles: (data) => {
    return articleApiInstance.patch(`/articles/${data.id}`, {
      title: data.title,
      content: data.content,
    });
  },
};
