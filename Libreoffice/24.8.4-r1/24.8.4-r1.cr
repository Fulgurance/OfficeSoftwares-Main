class Target < ISM::Software

    def prepare
        super

        makeLink(   target: "src/libreoffice-help-24.8.4.1/helpcontent2",
                    path:   "#{buildDirectoryPath}/helpcontent2",
                    type:   :symbolicLinkByOverwrite)
        makeLink(   target: "src/libreoffice-dictionaries-24.8.4.1/dictionaries",
                    path:   "#{buildDirectoryPath}/dictionaries",
                    type:   :symbolicLinkByOverwrite)
        makeLink(   target: "src/libreoffice-translations-24.8.4.1/translations",
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
                                --with-system-boost                                     \
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
                                --with-system-zlib                                      \
                                --with-system-libcdr                                    \
                                --with-system-librevenge                                \
                                --with-system-cppunit",
                path:           buildDirectoryPath)
    end

    def build
        super

        makeSource( arguments:  "build",
                    path:       buildDirectoryPath)
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

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/gid*")
    end

    def install
        super

        if option("Desktop-File-Utils")
            runUpdateDesktopDatabaseCommand
        end
    end

end
