#This file is also on building and testing, Not complete.
From alpine:3.15

ARG PROXYS=http://192.168.1.1:8888

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update --allow-untrusted && \
	apk upgrade --allow-untrusted && \
	apk add --no-cache --allow-untrusted --virtual build-dependencies \
	libressl-dev g++ make cmake gcc gfortran jpeg-dev zlib-dev python3-dev && \
	apk add --no-cache --allow-untrusted \
	python3 py-pip unzip libexif udev chromium chromium-chromedriver xvfb wget  ttf-freefont sudo openssl nginx nginx-mod-stream nginx-mod-rtmp ffmpeg py3-numpy curl && \
	rm -rf /tmp/* /var/cache/apk/* 

RUN export https_proxy=$PROXYS && \
	mkdir /noto && \
	cd /noto && \
#	wget -q "https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip" && \
	wget -q "https://src.fedoraproject.org/repo/extras/chromium/NotoSansCJKjp-hinted.zip/sha512/e7bcbc53a10b8ec3679dcade5a8a94cea7e1f60875ab38f2193b4fa8e33968e1f0abc8184a3df1e5210f6f5c731f96c727c6aa8f519423a29707d2dee5ada193/NotoSansCJKjp-hinted.zip" && \
	unzip NotoSansCJKjp-hinted.zip && \
	mkdir -p /usr/share/fonts/noto && \
	cp *.otf /usr/share/fonts/noto && \
	chmod 644 -R /usr/share/fonts/noto/ && \
	fc-cache -fv && \
	rm -rf /noto && \
	unset https_proxy

#COPY ~/volume1/Software/Linux/songti.ttf /
COPY songti.ttf /

RUN mkdir -p /usr/share/fonts/chinese && \
	mv /songti.ttf /usr/share/fonts/chinese/ && \
	cd /usr/share/fonts/chinese && \
	fc-cache -fv

RUN echo -e "*\t*\t*\t*\t*\trun-parts /etc/periodic/minutes" >> /var/spool/cron/crontabs/root && \
	echo -e "*/5\t*\t*\t*\t*\trun-parts /etc/periodic/5min" >> /var/spool/cron/crontabs/root && \
	echo -e "*/30\t*\t*\t*\t*\trun-parts /etc/periodic/30min" >> /var/spool/cron/crontabs/root && \
	sed -i "s/\/etc\/periodic/\/Crond/g" /var/spool/cron/crontabs/root && \
	chmod -R 777 /etc/crontabs && \
	mkdir -m 666 -p /Logs && \
	sed -i "s/\# do daily\/weekly\/monthly maintenance/\# do daily\/weekly\/monthly maintenance\nSHELL=\/bin\/sh/g" /var/spool/cron/crontabs/root && \
	sed -i "s/\# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers && \
	adduser admin -u 1024 -D -S -s /bin/sh -G wheel && \
	chmod 4755 /bin/busybox && \
	echo -e "t1st-pwd\nt1st-pwd" | passwd admin

RUN export https_proxy=$PROXYS && \
	python3 -m pip install --upgrade --proxy $PROXYS pip setuptools && \
	python3 -m pip install --upgrade --proxy $PROXYS selenium pyvirtualdisplay awscli boto3 requests pytz rarfile aprslib pyserial  pyecharts pymysql urllib3 pathlib flask pandas Pillow numpy && \
	unset https_proxy

#RUN export https_proxy=$PROXYS && \
#	python3 -m pip install --upgrade --proxy $PROXYS opencv-python-headless onnxruntime ddddocr && \
#	unset https_proxy	
	
RUN apk del build-dependencies

WORKDIR /Script

#CMD ["echo", "-e", "\"test\"", "|", "sudo", "-S", "/usr/sbin/crond","-f","-c","/var/spool/cron/crontabs","-L","/logs/cron.log","&&", "ping", "-t", "127.0.0.1"]

COPY ./init.sh /
RUN chmod 755 /init.sh
CMD ["/init.sh"]
#CMD ["python3"]
