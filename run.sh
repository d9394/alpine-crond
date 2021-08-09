#/bin/bash
aa=$(docker ps | grep "alpine-crond" | awk '{print$1}')
if [ "$aa" != "" ]; then
	echo stop containers : $aa
	docker stop $aa
fi
aa=$(docker ps -a | grep "alpine-crond" | awk '{print $1}')
if [ "$aa" != "" ]; then
	echo ready to delete containers : $aa
	docker rm $aa
fi
echo Start container alpine-crond @ `date` > ./Logs/cron.log
docker run -t -d \
  --name alpine-crond \
  --shm-size=1g \
  -u 1024:100 \
  -v /volume1/homes/docker/alpine-crond/Script/:/Script/ \
  -v /volume1/homes/docker/alpine-crond/Crond/:/Crond/ \
  -v /volume1/homes/docker/alpine-crond/Logs/:/Logs/ \
  -v /volume1/docker/alpine-etc-localtime:/etc/localtime \
  -v /volume1/Software:/Downloads/ \
  alpine-crond &
