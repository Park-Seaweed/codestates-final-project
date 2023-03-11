import axios from 'axios'

export const articleApi = {
    getArticles: () => {
        return axios.get('https://api.devops03-gg.click/articles');
    }
};




