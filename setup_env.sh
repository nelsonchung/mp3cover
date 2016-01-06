PWD_PATH=`pwd`
echo "PYTHON_UTILITY_PATH=$PWD_PATH" >> global_setting.sh

export PATH="$PWD:$PATH"

sudo apt-get install python-pip libcurl4-openssl-dev libssl-dev
sudo pip install pycurl
