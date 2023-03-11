import axios from 'axios'

export const getArticles = () => {
    return axios.get('https://api.devops03-gg.click/articles');
};