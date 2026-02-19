FROM docker.io/kasmweb/ubuntu-noble-desktop:1.17.0-rolling-daily
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV XDG_DATA_DIRS /usr/local/share:/usr/share:/var/lib/flatpak/exports/share
WORKDIR $HOME

######### Customize Container Here ###########


RUN touch $HOME/Desktop/hello.txt
RUN apt-get update && apt-get install -y build-essential dirmngr apt-transport-https ca-certificates software-properties-common btop htop inxi neofetch inkscape octave less screen pspp emacs-gtk elpa-ess texlive-latex-extra auctex preview-latex-style texlive-bibtex-extra texlive-fonts-extra texlive-formats-extra texlive-extra-utils texmaker  libwmf-bin  texlive-lang-german maxima-emacs maxima-share pspp flatpak
RUN gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | gpg --dearmor | sudo tee /usr/share/keyrings/cran.gpg > /dev/null
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" > /etc/apt/sources.list.d/cran.list
RUN apt-get update || /bin/true && apt-get install -y r-base r-base-dev
RUN wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2026.01.0-392-amd64.deb && dpkg -i rstudio-2026.01.0-392-amd64.deb || apt-get install -f -y
RUN perl -pi -e "s%/usr/lib/rstudio/rstudio%/usr/lib/rstudio/rstudio --no-sandbox %" /usr/share/applications/rstudio.desktop
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-linux-amd64.deb && dpkg -i quarto-1.8.27-linux-amd64.deb || apt-get install -f -y
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak update -y
RUN flatpak install -y app/org.onlyoffice.desktopeditors
RUN flatpak install -y app/org.telegram.desktop
RUN flatpak install -y app/org.signal.Signal
RUN flatpak install -y app/com.seafile.Client
RUN flatpak install -y app/com.xnview.XnViewMP
RUN flatpak install -y app/com.vivaldi.Vivaldi
RUN flatpak install -y com.github.IsmaelMartinez.teams_for_linux
RUN add-apt-repository ppa:obsproject/obs-studio && apt-get update || /bin/true && apt install -y obs-studio
RUN apt-get clean

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
