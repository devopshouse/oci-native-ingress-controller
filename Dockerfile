#
#  OCI Native Ingress Controller
#
#  Copyright (c) 2023 Oracle America, Inc. and its affiliates.
#  Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#

# For open source
FROM --platform=$BUILDPLATFORM golang:1.23.7-alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /workspace

COPY . ./

# Build
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GO111MODULE=on go build -mod vendor -a -o dist/onic ./main.go

# For Open source
FROM oraclelinux:8-slim

LABEL author="OKE Foundations Team"

WORKDIR /usr/local/bin/oci-native-ingress-controller

# copy license files
COPY LICENSE.txt .
COPY THIRD_PARTY_LICENSES.txt .

# Copy the manager binary
COPY --from=builder /workspace/dist/onic .

ENTRYPOINT ["/usr/local/bin/oci-native-ingress-controller/onic"]