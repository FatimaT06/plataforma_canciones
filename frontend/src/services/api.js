import axios from "axios";

const API = axios.create({
  baseURL: "http://plataformacanciones-production.up.railway.app/api"
});

export default API;
