# Start BMA Django app
cd ~/bma
GREP_OUTPUT=`ps -ef | grep '[0-9] /usr/bin/python3 manage.py runserver' | wc -l`
if [ "$GREP_OUTPUT" != "1" ]; then
	echo "Restarting BMA data server"
	python3 manage.py runserver >> django_server.log 2>&1 &
else
	echo "BMA data server still running"
fi
