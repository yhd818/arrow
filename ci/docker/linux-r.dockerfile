# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# General purpose Dockerfile to take a Docker image containing R
# and install Arrow R package dependencies

ARG base
FROM ${base}

# Make sure R is on the path for the R-hub devel versions (where RPREFIX is set in its dockerfile)
ENV PATH "${RPREFIX}/bin:${PATH}"
# Ensure parallel R package installation, set CRAN repo mirror,
# and use pre-built binaries where possible
COPY ci/etc/rprofile /arrow/ci/etc/
RUN cat /arrow/ci/etc/rprofile >> $(R RHOME)/etc/Rprofile.site

# Patch up some of the docker images
COPY ci/scripts/r_docker_configure.sh /arrow/ci/scripts/
RUN /arrow/ci/scripts/r_docker_configure.sh

COPY ci/scripts/r_deps.sh /arrow/ci/scripts/
COPY r/DESCRIPTION /arrow/r/
RUN /arrow/ci/scripts/r_deps.sh /arrow
