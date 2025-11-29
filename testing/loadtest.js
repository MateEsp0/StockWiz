import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 20,          
  duration: '10s',  
}

export default function () {
  const url = 'http://stockwiz-alb-67033981.us-east-1.elb.amazonaws.com/api/products';
  http.get(url);
  sleep(1); 
}
