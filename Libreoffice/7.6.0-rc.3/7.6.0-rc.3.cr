class Target < ISM::Software

    def prepare
        super

        makeLink(   target: "src/libreoffice-help-7.6.0.3/helpcontent2",
                    path:   "#{buildDirectoryPath}/helpcontent2",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "src/libreoffice-dictionaries-7.6.0.3/dictionaries",
                    path:   "#{buildDirectoryPath}/dictionaries",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "src/libreoffice-translations-7.6.0.3/translations",
                    path:   "#{buildDirectoryPath}/translations",
                    type:   :symbolicLinkByOverwrite)
    end
    
    def configure
        super

        runFile(file:           "autogen.sh",
                arguments:      "--prefix=/usr                                          \
                                --sysconfdir=/etc                                       \
                                --with-vendor=#{Ism.settings.systemName}                \
                                --with-lang=\'en-GB\'                                   \
                                --with-help                                             \
                                --with-myspell-dicts                                    \
                                --without-junit                                         \
                                --without-system-dicts                                  \
                                --disable-dconf                                         \
                                --disable-odk                                           \
                                --without-java                                          \
                                --enable-release-build=yes                              \
                                --enable-python=system                                  \
                                --with-jdk-home=/opt/jdk                                \
                                #{option("Cups") ? "--enable-cups" : "--disable-cups"}  \
                                --with-system-clucene                                   \
                                --with-system-curl                                      \
                                --with-system-epoxy                                     \
                                --with-system-expat                                     \
                                --with-system-glm                                       \
                                --with-system-gpgmepp                                   \
                                --with-system-graphite                                  \
                                --with-system-harfbuzz                                  \
                                --with-system-icu                                       \
                                --with-system-jpeg                                      \
                                --with-system-lcms2                                     \
                                --with-system-libatomic_ops                             \
                                --with-system-libpng                                    \
                                --with-system-libxml                                    \
                                --with-system-nss                                       \
                                --with-system-odbc                                      \
                                --with-system-openldap                                  \
                                --with-system-openssl                                   \
                                --with-system-poppler                                   \
                                --with-system-postgresql                                \
                                --with-system-redland                                   \
                                --with-system-libtiff                                   \
                                --with-system-libwebp                                   \
                                --with-system-zlib",
                path:           buildDirectoryPath,
                asNormalUser:   true)
    end

    def build
        super

        makeSource( arguments:  "build",
                    path:       buildDirectoryPath,
                    asNormalUser:   true)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} distro-pack-install",
                    path:       buildDirectoryPath)

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libreoffice/share/xdg/draw.desktop",
                        text:       "Categories=Office;FlowChart;Graphics;2DGraphics;VectorGraphics;X-Red-Hat-Base;",
                        newText:    "Categories=Office;")

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libreoffice/share/xdg/math.desktop",
                        text:       "Categories=Office;Education;Science;Math;X-Red-Hat-Base;",
                        newText:    "Categories=Office;")
    end

    def install
        super

        if option("Desktop-File-Utils")
            runUpdateDesktopDatabaseCommand
        end
    end

end
