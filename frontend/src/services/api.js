import axios from "axios";

const API = axios.create({
  baseURL: "https://plataformacanciones-production.up.railway.app/api"
  //baseURL: "http://localhost:3000/api"
});

export default API;
