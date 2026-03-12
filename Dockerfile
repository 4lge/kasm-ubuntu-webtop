FROM docker.io/kasmweb/ubuntu-noble-desktop:1.17.0-rolling-daily
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV XDG_DATA_DIRS /usr/local/share:/usr/share:/var/lib/flatpak/exports/share
WORKDIR $HOME

######### Customize Container Here ###########


RUN touch $HOME/Desktop/hello.txt
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y build-essential dirmngr apt-transport-https ca-certificates \
  software-properties-common btop htop inxi neofetch inkscape octave less screen pspp emacs-gtk elpa-ess texlive-latex-extra auctex \
  preview-latex-style texlive-bibtex-extra texlive-fonts-extra texlive-formats-extra texlive-extra-utils texmaker  libwmf-bin \
  texlive-lang-german maxima-emacs maxima-share pspp flatpak libssl-dev libclang-dev cmake libxml2-dev libfontconfig1-dev autorandr \
  libharfbuzz-dev libfribidi-dev fonts-inconsolata g++ git make ocl-icd-libopencl1 ocl-icd-opencl-dev pocl-opencl-icd openjdk-25-jdk \
  mc gdb valgrind && apt clean
RUN gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | gpg --dearmor | sudo tee /usr/share/keyrings/cran.gpg > /dev/null
RUN echo "deb http://ftp.texmacs.org/TeXmacs/tmftp/repos/apt/ bookworm universe" > /etc/apt/sources.list.d/texmacs.list; \
  wget https://ftp.texmacs.org/TeXmacs/tmftp/repos/apt/apt-texmacs.asc ; \
  apt-key add apt-texmacs.asc ; \
  apt-get update ; \
  apt-get install -y texmacs
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" > /etc/apt/sources.list.d/cran.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 || /bin/true
RUN apt-get update || /bin/true && apt-get install -y r-base r-base-dev
RUN wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2026.01.1-403-amd64.deb; \
  dpkg -i rstudio-2026.01.1-403-amd64.deb || apt-get install -f -y
RUN perl -pi -e "s%/usr/lib/rstudio/rstudio%/usr/lib/rstudio/rstudio --no-sandbox %" /usr/share/applications/rstudio.desktop
RUN R CMD javareconf || /bin/true
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-linux-amd64.deb && dpkg -i quarto-1.8.27-linux-amd64.deb || apt-get install -f -y
RUN wget https://downloads.vivaldi.com/stable/vivaldi-stable_7.8.3925.70-1_amd64.deb && dpkg -i vivaldi-stable_7.8.3925.70-1_amd64.deb || apt-get install -f -y
RUN perl -pi -e "s%vivaldi-stable%vivaldi-stable --no-sandbox %" /usr/share/applications/vivaldi-stable.desktop
RUN for i in libseafile0t64_9.0.14-1_amd64.deb seafile-cli_9.0.14-1_all.deb python3-seafile_9.0.14-1_all.deb \
         seafile-daemon_9.0.14-1_amd64.deb  seafile-gui_9.0.14_amd64.deb; do \
  wget https://www.algepop.net/users/alge/seafile-9.0.14-ubuntu24.04/$i; \
done; \
dpkg -i *seafile*.deb || /bin/true; \
apt-get install -f -y; \
rm -f *.deb 
RUN add-apt-repository ppa:obsproject/obs-studio && apt-get update || /bin/true 
RUN wget https://www.betterbird.eu/downloads/LinuxArchive/betterbird-140.8.0esr-bb19.en-US.linux-x86_64.tar.xz; \
  tar xJvfp betterbird-140.8.0esr-bb19.en-US.linux-x86_64.tar.xz; \
  mv betterbird /opt; ln -sf /opt/betterbird/betterbird /usr/bin/betterbird; \
  wget https://www.algepop.net/users/alge/Betterbird\ Mail.desktop; \
  mv Betterbird\ Mail.desktop /usr/share/applications/
RUN apt install -y obs-studio && apt-get clean
# RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak update -y
# RUN flatpak install -y app/com.github.IsmaelMartinez.teams_for_linux

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
