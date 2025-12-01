import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '10s',
};

export default function () {
  const baseUrl = 'http://stockwiz-alb-67033981.us-east-1.elb.amazonaws.com';

  // Test Product list
  http.get(`${baseUrl}/api/products`);

  // Test Inventory list
  http.get(`${baseUrl}/api/inventory`);

  // Test health check
  http.get(`${baseUrl}/api/health`);

  sleep(1);
}
