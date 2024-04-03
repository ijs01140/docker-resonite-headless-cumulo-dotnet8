FROM steamcmd/steamcmd:latest AS Downloader
ARG	STEAMLOGIN \
    STEAMBETAPASSWORD
ENV	STEAMAPPID=2519830 \
	STEAMBETA=headless 
ENV	RESONITEDIR="/tmp/resonite-headless"

RUN bash "/usr/bin/steamcmd" \
	+force_install_dir ${RESONITEDIR} \
	+login ${STEAMLOGIN} \
	+app_license_request ${STEAMAPPID} \
	+app_update ${STEAMAPPID} -beta ${STEAMBETA} -betapassword ${STEAMBETAPASSWORD} validate \
	+quit


FROM ijs01140/mono:6.12.0.200 AS Patcher
ENV	RESONITEDIR="/tmp/resonite-headless"
ENV	HEADLESSDIR=${RESONITEDIR}/Headless

RUN	apt-get -y update && \
	apt-get -y install unzip && \
	rm -rf /var/lib/{apt,dpkg,cache}

RUN mkdir -p /root/Cumulo_Patcher
ADD https://github.com/BlueCyro/Cumulo/releases/download/1.0.1/Cumulo_Patcher.zip /root/Cumulo_Patcher
WORKDIR /root/Cumulo_Patcher

COPY --from=Downloader ${RESONITEDIR} ${RESONITEDIR}
RUN mkdir ${HEADLESSDIR}/Libraries && mkdir ${HEADLESSDIR}/rml_libs
ADD https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll ${HEADLESSDIR}/Libraries
ADD https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/0Harmony.dll ${HEADLESSDIR}/rml_libs

RUN unzip Cumulo_Patcher.zip && \
	rm Cumulo_Patcher.zip && \
	mono /root/Cumulo_Patcher/Cumulo.exe --noconfirm ${HEADLESSDIR}


FROM mcr.microsoft.com/dotnet/runtime:8.0
ENV	HEADLESSDIR="/root/resonite-headless"

RUN	apt-get -y update && \
	apt-get -y install curl lib32gcc-s1 libopus-dev libopus0 opus-tools libc-dev && \
	rm -rf /var/lib/{apt,dpkg,cache}

COPY --from=Patcher /tmp/resonite-headless/Headless ${HEADLESSDIR}

WORKDIR ${HEADLESSDIR}
CMD dotnet "/root/resonite-headless/Resonite.exe" -HeadlessConfig /Config/Config.json -Logs /Logs -LoadAssembly Libraries/ResoniteModLoader.dll
