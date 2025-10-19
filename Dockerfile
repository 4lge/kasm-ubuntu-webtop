FROM docker.io/kasmweb/ubuntu-noble-desktop:1.17.0-rolling-daily
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


RUN touch $HOME/Desktop/hello.txt
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install dirmngr apt-transport-https ca-certificates software-properties-common -y
RUN gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | gpg --dearmor | sudo tee /usr/share/keyrings/cran.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/debian bookworm-cran40/" > /etc/apt/sources.list.d/cran.list
RUN apt-get update
RUN apt-get install -y r-base r-base-dev
RUN wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.09.1-401-amd64.deb && dpkg -i rstudio-2025.09.1-401-amd64.deb || apt-get install -f -y
RUN perl -pi -e "s%/usr/lib/rstudio/rstudio%/usr/lib/rstudio/rstudio --no-sandbox %" /usr/share/applications/rstudio.desktop
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.25/quarto-1.8.25-linux-amd64.deb && dpkg -i quarto-1.8.25-linux-amd64.deb || apt-get install -f -y
RUN apt-get install -y pspp emacs-gtk elpa-ess texlive-latex-extra auctex preview-latex-style texlive-bibtex-extra texlive-fonts-extra texlive-formats-extra texlive-extra-utils
RUN apt install -y texmaker  libwmf-bin  texlive-lang-german 
RUN apt install -y flatpak
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
RUN flatpak update -y
RUN wget https://cdn.zoom.us/prod/6.6.0.4410/zoom_amd64.deb && dpkg -i zoom_amd64.deb || apt-get install -f -y
RUN add-apt-repository ppa:obsproject/obs-studio
RUN apt install -y obs-studio
RUN apt-get clean

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
