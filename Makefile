SHELL = $(PWD)/shim/shell

.EXPORT_ALL_VARIABLES:
BUILD_DIR=build
APPS=quotes newsfeed front-end
LIBS=common-utils
STATIC_BASE=front-end/public
STATIC_PATHS=css
STATIC_ARCHIVE=$(BUILD_DIR)/static.tgz
INSTALL_TARGETS=$(addsuffix .install, $(LIBS))
APP_JARS=$(addprefix $(BUILD_DIR)/, $(addsuffix .jar, $(APPS)))


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

all: $(BUILD_DIR) $(APP_JARS) $(STATIC_ARCHIVE)

libs: $(INSTALL_TARGETS)

static: $(STATIC_ARCHIVE)

%.install:
	cd $* && lein install

test: $(addsuffix .test, $(LIBS) $(APPS))

%.test:
	cd $* && lein midje

container: $(addsuffix .container,  $(APPS))

%.container:
	docker build -f $*/Dockerfile -t $(LOCAL_REGISTRY)/$*:$(LOCAL_TAG) .

login:
	echo ${DOCKER_PASS} | docker login --username ${DOCKER_USER} --password-stdin $(REMOTE_REGISTRY)
.PHONY: login

tag: $(addsuffix .tag,  $(APPS))

%.tag:
	docker tag $(LOCAL_REGISTRY)/$*:$(LOCAL_TAG) $(REMOTE_REGISTRY)/$*:$(RELEASE_TAG)

push: $(addsuffix .push,  $(APPS))
	
%.push:
	docker push $(REMOTE_REGISTRY)/$*:$(RELEASE_TAG)

deploy: $(addsuffix .deploy,  $(APPS))

%.deploy:
	$*/scripts/patch-deploy.sh $*

clean:
	rm -rf $(BUILD_DIR) $(addsuffix /target, $(APPS))


$(APP_JARS): | $(BUILD_DIR)
	cd $(notdir $(@:.jar=)) && lein uberjar && cp target/uberjar/*-standalone.jar ../$@

$(STATIC_ARCHIVE): | $(BUILD_DIR)
	tar -c -C $(STATIC_BASE) -z -f $(STATIC_ARCHIVE) $(STATIC_PATHS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

