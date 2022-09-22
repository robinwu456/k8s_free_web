FROM ubuntu:20.04
#COPY free_web_server /free_web_server
#COPY free_web.env /free_web_server/

ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN \
  apt-get update && \
  apt-get install -y curl python2.7 vim build-essential git && \
  update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 && \
  curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
  python get-pip.py

# PIL
RUN \
  apt-get install -y python-dev python-pil && \
  apt-get build-dep python-imaging; exit 0

RUN apt-get install -y libjpeg62 libjpeg62-dev

# uWSGI
RUN \
  pip install uwsgi && \
  mkdir /var/log/uwsgi && \
  touch /var/log/uwsgi/free_web.log && \
  chmod 777 /var/log/uwsgi/free_web.log

# git pull free_web_server
COPY ssh/ /root/.ssh/
RUN \
  chmod 600 /root/.ssh/config && \
  chmod 600 /root/.ssh/id_rsa && \
  chmod 600 /root/.ssh/id_rsa.pub && \
  git clone git@bitbucket.org:robinwu456/free_web_server.git
COPY free_web.env /free_web_server/
COPY free_web.ini /free_web_server/
COPY plugin/ /free_web_server/srcs/server_common/


CMD ["uwsgi", "--ini", "/free_web_server/free_web.ini"]
