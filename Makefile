VERSION := $(shell grep -oP 'CC_VERSION="\K[^"]+' cc)

.PHONY: build clean version bump-patch bump-minor bump-major

build:
	@bash build-deb.sh

clean:
	@rm -rf dist/

version:
	@echo $(VERSION)

bump-patch:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$ma.$$mi.$$((pa + 1))"; \
	sed -i "s/CC_VERSION=\"$(VERSION)\"/CC_VERSION=\"$$NEW\"/" cc; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"

bump-minor:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$ma.$$((mi + 1)).0"; \
	sed -i "s/CC_VERSION=\"$(VERSION)\"/CC_VERSION=\"$$NEW\"/" cc; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"

bump-major:
	@IFS='.' read -r ma mi pa <<< "$(VERSION)"; \
	NEW="$$((ma + 1)).0.0"; \
	sed -i "s/CC_VERSION=\"$(VERSION)\"/CC_VERSION=\"$$NEW\"/" cc; \
	sed -i "s/^Version:.*/Version: $$NEW/" debian/control; \
	echo "$(VERSION) -> $$NEW"
