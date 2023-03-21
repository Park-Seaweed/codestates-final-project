import axios from 'axios';

const userApiInstance = axios.create({
  baseURL: process.env.BACK_END_URL,
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
  verify: (data) => {
    return userApiInstance.post('/auth/verify', data);
  },
};
