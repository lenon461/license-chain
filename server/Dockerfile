FROM node:carbon
MAINTAINER lenon461@gmail.com
 
RUN mkdir -p /app
WORKDIR /app
ADD ./ /app
 
 
#패키지파일들 받기
RUN npm install
 
#배포버젼으로 설정 - 이 설정으로 환경을 나눌 수 있습니다.
ENV NODE_ENV=production
 
#서버실행
CMD node app.js
