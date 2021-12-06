FROM centos:7

WORKDIR /

# устанавливаем ПО, необходимое для установки
RUN yum -y install wget && \
    yum -y install perl-Digest-SHA

# из под рута ES не работает, поэтому создаем нового пользователя
RUN groupadd -g 1000 elasticsearch && \
    useradd elasticsearch -u 1000 -g 1000

# загружаем и устанавливаем elastic 
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz .
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 .

RUN shasum -a 512 -c elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.15.2-linux-x86_64.tar.gz && \
    cd elasticsearch-7.15.2/

# создаем отдельную директорию для данных БД
RUN mkdir /var/lib/elasticsearch

# добавляем предварительно настроенный файл конфига
COPY elasticsearch.yml elasticsearch-7.15.2/config/

# назначаем права
RUN chown -R elasticsearch:elasticsearch /elasticsearch-7.15.2/ && \
    chown -R elasticsearch:elasticsearch /var/lib/elasticsearch && \
    chown -R 1000:1000 /var/lib/elasticsearch

USER elasticsearch

#работаем с окружением и портами
ENV PATH=$PATH:/elasticsearch-7.15.2/bin

EXPOSE 9200 9300

ENTRYPOINT ["elasticsearch"]
