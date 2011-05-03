# -*- Makefile -*-
# 
buildtree=build-tree/
sourcedir=w3m-0.1.11-pre
builddir=$(buildtree)/$(sourcedir)

extract: extract-stamp
extract-stamp:
	-rm -rf $(buildtree)
	mkdir $(buildtree)
	tar zxfC upstream/w3m-0.1.11-pre.tar.gz $(buildtree)
	# gunzip < upstream/w3m-0.1.11-pre+.diff.gz | (cd $(builddir) && patch -p0)
	gunzip < upstream/w3m-0.1.11-pre-kokb23.patch.gz | (cd $(builddir) && patch -p1)
	touch extract-stamp

patch: patch-stamp
patch-stamp: extract-stamp
	for p in debian/patches/[0-9]*; \
	do \
		test -f $$p || continue; \
		patchopt=`sed -ne '1s/PATCH: \(.*\)/\1/p' $$p`; \
		echo "Patch: $$p ($$patchopt)"; \
		cat $$p | (cd $(builddir) && patch $$patchopt); \
	done
	touch patch-stamp


buildjadir=$(buildtree)/$(sourcedir)-ja
buildendir=$(buildtree)/$(sourcedir)-en

setup-ja: $(buildjadir)/setup-stamp
$(buildjadir)/setup-stamp: extract-stamp patch-stamp
	-rm -rf $(buildjadir)
	cp -a $(builddir) $(buildjadir)
	touch $(buildjadir)/setup-stamp

setup-en: $(buildendir)/setup-stamp
$(buildendir)/setup-stamp: extract-stamp patch-stamp
	-rm -rf $(buildendir)
	cp -a $(builddir) $(buildendir)
	touch $(buildendir)/setup-stamp
