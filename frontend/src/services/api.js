import axios from "axios";

const API = axios.create({
  baseURL: "https://plataformacanciones-production.up.railway.app/api"
});

export default API;
