
package FMdata;
use base 'Exporter';
our @EXPORT_OK = qw/get_api_info/;

our $api = {

    fetch_available_licenses => {
        desc    => 'Fetch all available licenses',
        params  => [],
        returns => [ qw/Array of available licenses/ ],
    },
        
    fetch_available_release_foci => {
        desc    => 'Fetch all available release focus types',
        params  => [],
        returns => [ qw/Struct of available release focus types and associated IDs/ ],
    },
    
    fetch_branch_list => {
        desc    => 'Fetch all branch names and IDs for a given project', 
        params  => [ qw/SID project_name/ ],
        returns => [ qw/Array of branch name strings./ ],
    },
        
    fetch_project_list => {
        desc    => 'Fetch all projects assigned to logged in user',
        params  => [ qw/SID/ ],
        returns => [ qq{Array of structs consisting of "projectname_full", "projectname_short", "project_status", and "project_version"} ],
    },
        
    fetch_release => {
        desc    => 'Fetch data from a pending release submission',
        params  => [ qw/SID project_name branch_name version/ ],
        returns => [ qq{Struct consisting of "version", "changes", "release_focus", and "hide_from_frontpage"} ],
    },
    
    login => {
        desc    => 'Start an XML-RPC session',
        params  => [ qw/username password/ ],
        returns => [ 'SID', 'Lifetime', 'API Version' ],
    },
    
    logout => {
        desc    => 'End an XML-RPC session',
        params  => [ qw/SID/ ],
        returns => [ qq{Struct of "OK" => "Logout successful." if logout was successful} ],
    },
    
    publish_release	=> {
        desc    => 'Publish a new release',
        params  => [ qw/
            SID project_name branch_name version changes release_focus hide_from_frontpage
            license url_homepage url_tgz url_bz2 url_zip url_changelog url_rpm url_deb 
            url_osx url_bsdport url_purchase url_cvs url_list url_mirror url_demo	   
        / ],
        returns => [ qq{Struct of "OK" => "submission successful"} ],
    },
    
    withdraw_release => {
        desc    => 'Take back a release submission',
        params  => [ qw/SID project_name branch_name version/ ],
        returns => [ qq{Struct of "OK" => "Withdraw successful."} ],
    },
};

# [ Appendix A: Release focus IDs ]
# 0 - N/A
# 1 - Initial freshmeat announcement
# 2 - Documentation
# 3 - Code cleanup
# 4 - Minor feature enhancements
# 5 - Major feature enhancements
# 6 - Minor bugfixes
# 7 - Major bugfixes
# 8 - Minor security fixes
# 9 - Major security fixes
# 
# 
# [ Appendix B: Error codes ]
#  10 - Login incorrect
#  20 - Session inconsistency
#  21 - Session invalid
#  30 - Branch ID incorrect
#  40 - Permission to publish release denied
#  50 - Version string missing
#  51 - Duplicate version string
#  60 - Changes field empty
#  61 - Changes field too long
#  62 - Changes field contains HTML
#  70 - No valid email address set
#  80 - Release not found
#  81 - Project not found
#  90 - Release focus missing
#  91 - Release focus invalid
# 100 - License invalid
# 999 - Unknown error

sub get_api_info { $api }

1;
    
