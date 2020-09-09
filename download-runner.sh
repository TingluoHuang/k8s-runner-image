#!/bin/bash
set -e

# if the scope has a slash, it's a repo runner
# orgs_or_repos="orgs"
# if [[ "$GITHUB_RUNNER_SCOPE" == *\/* ]]; then
#     orgs_or_repos="repos"
# fi

#RUNNER_DOWNLOAD_URL=$(curl -s -X GET ${GITHUB_API_URL}/${orgs_or_repos}/${GITHUB_RUNNER_SCOPE}/actions/runners/downloads -H "authorization: token $GITHUB_PAT" -H "accept: application/vnd.github.everest-preview+json" | jq -r '.[]|select(.os=="linux" and .architecture=="x64")|.download_url')

# download actions and unzip it
#curl -Ls ${RUNNER_DOWNLOAD_URL} | tar xz \

#curl -Ls https://github.com/TingluoHuang/runner/releases/download/test/actions-runner-linux-x64-2.299.0.tar.gz | tar xz

# delete the download tar.gz file
#rm -f ${RUNNER_DOWNLOAD_URL##*/}
if [ -n "${RUNNER_DOWNLOAD_URL}" ]; then
  # For the GHES Alpha, download the runner from github.com
  latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
  latest_version=$(echo ${latest_version_label:1})
  runner_file="actions-runner-linux-x64-${latest_version}.tar.gz"

  runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}"

  echo "Downloading ${latest_version_label} for ${runner_plat} ..."
  echo $runner_url

  curl -O -L ${runner_url}

  ls -la *.tar.gz

  #---------------------------------------------------
  # extract to runner directory in this directory
  #---------------------------------------------------
  echo
  echo "Extracting ${runner_file} to ./runner"

  mkdir runner
  tar xzf "./${runner_file}" -C runner
else
  mkdir runner
  cd runner
  curl -Ls ${RUNNER_DOWNLOAD_URL} | tar xz

  # delete the download tar.gz file
  rm -f ${RUNNER_DOWNLOAD_URL##*/}
fi

