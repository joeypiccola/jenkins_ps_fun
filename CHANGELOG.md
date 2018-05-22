# Changelog
All notable changes to this project will be documented here.

## [1.0.18] - 2018-05-17
### Added
- AD computer object cleanup on failed deployment
- OS customization specification cleanup on failed deployment
- support for sufficient space checks on standalone datastore

### Fixed
- OS customization specification not called during deployment

## [1.0.17] - 2018-05-14
### Added
- set resource pool to normal if available

## [1.0.16] - 2018-05-10
### Added
- datastore cluster validation checks

## [1.0.15] - 2018-05-09
### Added
- allow for active directory replication before rebooting at end

## [1.0.14] - 2018-05-02
### Remove
- set resource pool code

## [1.0.13] - 2018-04-29
### Changed
- update token to production HipChat
- increased timeout logic on Invoke-VMScript

## [1.0.12] - 2018-04-27
### Changed
- moved HipChat room name to var
- update pipeline stage names

## [1.0.11] - 2018-04-23
### Added
- QA creds
- default and den2 deployment VLANs

### Fixed
- silently continue when resource pool is not found

## [1.0.10] - 2018-04-19
### Added
- logic to extend C:\

## [1.0.9] - 2018-04-18
### Changed
- increased static ip check timeout
- increased dhcp ip check timeout
- increased job timeout


## [1.0.8] - 2018-04-17
### Added
- set resource pool logic

## [1.0.7] - 2018-04-16
### Added
- build description var for use with build desc in job
- requestor to job param
- requestor to build description

### Changed
- use hipchatsend plugin for notifications vs PowerShell API call
- move cleanWS inside of post block and call them last

### Fixed
- double quotes for HipChat var expansion
- HipChat calls in post block not executing

## [1.0.6] - 2018-04-12
### Added
- conditional build steps logic for AD

## [1.0.5] - 2018-04-10
### Added
- job display name

### Changed
- increased static ip check timeout

## [1.0.4] - 2018-04-09
### Added
- more parallelization of steps
- get VM pre-req checks

### Changes
- deployment vlan updates
- moved stages around to support parallelization

## [1.0.3] - 2018-04-04
### Changed
- updated OUs for the various ADs

## [1.0.2] - 2018-03-15
### Added
- support for staging OU in AD

### Changed
- updated OUs
- reduced sysprep wait 4 to 3

## [1.0.1] - 2018-03-14
### Added
- branch param for vmware runonce

### Changed
- reduced sysprep wait 10 to 4

### Fixed
- OU logic for workgroup

## [1.0.0] - 2018-03-13
### Added
- initial commit
