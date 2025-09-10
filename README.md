## Репозиторий app.git содержит

_Весь код и все тесты, а также k8s и gitlab я разворачивал локально на своем компе._


### Сервис
- В папке  `./geo-app/app/` хранится код fastapi приложения написанного на python которое соответсвует требованиям:
	* REST API /ping на FastAPI (Python), docker-compose (БД в redis контейнере), Нагрузочное тестирование (ab, wrk, hey), Метрики Prometheus /metrics (RPS, задержка, ошибки).
- Также В папке `.\geo-app\app\README.md` сть README.md файл c инструкциями


###  Контейнеризация
- В папке `./geo-app/docker `находится Dockerfile для сборки приложения в docker
- Также В папке `./github/geo-app/docker/` есть REAME.md файл c инструкциями
- контейнер в собраном виде занимает ~150-170 Mb


### Kubernetes 
Развернул kubeadm на 2 ВМ (master и worker nodes)
- Установил туда nginx ingress-controller c оф. сайта


### 3. CI/CD (GitLab)
Создал директорию с helm-chart в репозитории  `./geo-app/helm` и создалл gitlab pipeline (лежит в корне репозитория) который:
1. из папки `/app`берет код и упаковывает его в докер образ. 
2. пушит собранный образ в gitlab-registry
3. обновляет hekm-chart чтобы он использовал новый образ
4. делаеи helm-lint м если все ОК
5. Деплоет или обновляет helm-release в ns dev в k8s
тоесть по сути в одном пайплайне Build + push Docker-образа в GitLab Registry + helm lint + deploy в namespace dev.

