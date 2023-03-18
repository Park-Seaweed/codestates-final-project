import axios from 'axios';

export const articleApi = {
  getArticles: () => {
    return axios.get(`${process.env.REACT_APP_BACK_END_URL}/articles`);
  },
  addArticles: (data) => {
    return axios.post(`${process.env.REACT_APP_BACK_END_URL}/articles`, data);
  },
  deleteArticles: (data) => {
    return axios.delete(
      `${process.env.REACT_APP_BACK_END_URL}/articles/${data}`
    );
  },
};
