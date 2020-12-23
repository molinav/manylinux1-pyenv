ALL = $(shell echo "2.6 2.7 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9")


build:

	@if [ "$(version)" = "all" ]; then                                    \
            for v in $(ALL); do                                               \
                make build version="$$v";                                     \
            done                                                              \
	else                                                                  \
	    tag="manylinux1-pyenv:$$version";                                 \
	    echo "Building $$tag...";                                         \
            docker build -q --tag "$$tag" . --build-arg version="$(version)"; \
        fi


publish:

	@if [ "$(version)" = "all" ]; then                                    \
            for v in $(ALL); do                                               \
                make publish version="$$v";                                   \
            done;                                                             \
	    make publish version=latest;                                      \
	else                                                                  \
	    user=$$(docker info 2>/dev/null | sed -n '/[ ]*Username:/p'       \
	            | rev | cut -d' ' -f1 | rev);                             \
	    if [ "$(version)" = "latest" ]; then                              \
                version=$$(echo $(ALL) | rev | cut -d' ' -f1 | rev);          \
	        tag="manylinux1-pyenv:$$version";                             \
	        repotag=$$user/manylinux1-pyenv:latest;                       \
	    else                                                              \
	        tag="manylinux1-pyenv:$$version";                             \
	        repotag=$$user/$$tag;                                         \
	    fi;                                                               \
	    id=$$(docker images -q $$tag);                                    \
	    echo "Publishing $$repotag... $$id";                              \
	    docker tag "$$id" "$$repotag";                                    \
	    docker push "$$repotag";                                          \
        fi
