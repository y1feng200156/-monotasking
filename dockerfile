FROM python:2-buster
MAINTAINER hi@charles-t.com

RUN cd ~ && git clone https://github.com/Hammerspoon/hammerspoon.git && cd ./hammerspoon && pip install --user -r requirements.txt