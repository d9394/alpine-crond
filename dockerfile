#This file is also on building and testing, Not complete.
From alpine:edge

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk upgrade && \
	apk add --no-cache \
	python3 py-pip unzip libexif udev chromium chromium-chromedriver xvfb wget unrar libressl-dev ttf-freefont sudo && \
	rm -rf /tmp/* /var/cache/apk/*

RUN export https_proxy=http://127.0.0.1:8888 && \
	mkdir /noto && \
	cd /noto && \
	wget "https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip" && \
#	wget https://www.hellocq.net/NotoSansCJKjp-hinted.zip && \
	unzip NotoSansCJKjp-hinted.zip && \
	mkdir -p /usr/share/fonts/noto && \
	cp *.otf /usr/share/fonts/noto && \
	chmod 644 -R /usr/share/fonts/noto/ && \
	fc-cache -fv && \
	rm -rf /noto && \
	unset https_proxy

RUN echo -e "*\t*\t*\t*\t*\trun-parts /etc/periodic/minutes" >> /var/spool/cron/crontabs/root && \
	echo -e "*/5\t*\t*\t*\t*\trun-parts /etc/periodic/5min" >> /var/spool/cron/crontabs/root && \
	sed -i "s/\/etc\/periodic/\/Crond/g" /var/spool/cron/crontabs/root && \
	chmod -R 777 /etc/crontabs && \
	mkdir -m 666 -p /Logs && \
	sed -i "s/\# do daily\/weekly\/monthly maintenance/\# do daily\/weekly\/monthly maintenance\nSHELL=\/bin\/sh/g" /var/spool/cron/crontabs/root && \
	sed -i "s/\# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers && \
	adduser admin -u 1024 -D -S -s /bin/bash -G wheel && \
	chmod 4755 /bin/busybox && \
	echo -e "test\ntest" | passwd admin

RUN pip3 install --upgrade --proxy http://127.0.0.1:8888 selenium pyvirtualdisplay awscli boto3 requests pytz rarfile aprslib pyserial  pyecharts pymysql

WORKDIR /Script

ADD ./init.sh /
RUN chmod 755 /init.sh
CMD ["/init.sh"]
#CMD ["python3"]
