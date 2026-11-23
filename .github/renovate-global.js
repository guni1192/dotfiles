// Admin config for the self-hosted Renovate process.
// allowedCommands is ignored when it is set in renovate.json.
// Keep this list to the one checksum command that process runs.
module.exports = {
  platform: 'github',
  repositories: ['guni1192/dotfiles'],
  autodiscover: false,
  onboarding: false,
  requireConfig: 'required',
  gitAuthor:
    'github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>',
  allowedCommands: [
    '^aqua update-checksum --prune -c checksum-sources\\.yaml$',
  ],
};
