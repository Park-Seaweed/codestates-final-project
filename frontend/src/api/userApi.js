import axios from 'axios';

const userApiInstance = axios.create({
  baseURL: process.env.REACT_APP_BACK_END_URL,
});

export const userApi = {
  signIn: (data) => {
    return userApiInstance.post('/auth/login', data);
  },
  signOut: (config) => {
    return userApiInstance.post('/auth/logout', {}, config);
  },
  signUp: (data) => {
    return userApiInstance.post('/auth/signup', data);
  },
};
