docker build -t wbapi .
docker run -d --name wbapi -p 8080:8080 -p 8081:8081 wbapi:latest
docker ps



https://localhost:8081/WeatherForecast