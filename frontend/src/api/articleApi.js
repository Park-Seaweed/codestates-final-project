import axios from 'axios'


export const articleApi = {
    getArticles: () => {
        return axios.get(process.env.REACT_APP_BACK_END_URL);
    },
    addArticles: (data) => {
        return axios.post(process.env.REACT_APP_BACK_END_URL, data)
    },
    deleteArticles: (data) => {
        return axios.delete(`${process.env.REACT_APP_BACK_END_URL}/${data}`)
    }
};





