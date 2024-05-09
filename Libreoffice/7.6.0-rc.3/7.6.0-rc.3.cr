class Target < ISM::Software
    
    def configure
        super

        runScript(      "autogen.sh",
                    [   "--prefix=/usr",
                        "--sysconfdir=/etc",
                        "--with-vendor=#{Ism.settings.systemName}",
                        "--with-lang=\'en-GB\'",
                        "--with-help",
                        "--with-myspell-dicts",
                        "--without-junit",
                        "--without-system-dicts",
                        "--disable-dconf",
                        "--disable-odk",
                        "--without-java"
                        "--enable-release-build=yes",
                        "--enable-python=system",
                        "--with-jdk-home=/opt/jdk",
                        "--with-system-clucene",
                        "--with-system-curl",
                        "--with-system-epoxy",
                        "--with-system-expat",
                        "--with-system-glm",
                        "--with-system-gpgmepp",
                        "--with-system-graphite",
                        "--with-system-harfbuzz",
                        "--with-system-icu",
                        "--with-system-jpeg",
                        "--with-system-lcms2",
                        "--with-system-libatomic_ops",
                        "--with-system-libpng",
                        "--with-system-libxml",
                        "--with-system-nss",
                        "--with-system-odbc",
                        "--with-system-openldap",
                        "--with-system-openssl",
                        "--with-system-poppler",
                        "--with-system-postgresql",
                        "--with-system-redland",
                        "--with-system-libtiff",
                        "--with-system-libwebp",
                        "--with-system-zlib"],
                        path: buildDirectoryPath)
    end

    def build
        super

        makeSource(["build"], path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","distro-pack-install"],buildDirectoryPath)
    end

    def install
        super

        if option("Desktop-File-Utils")
            runUpdateDesktopDatabaseCommand
        end
    end

end
