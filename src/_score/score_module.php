<?php
/**
 * Materia
 * It's a thing
 *
 * @package	    Materia
 * @version    1.0
 * @author     UCF New Media
 * @copyright  2011 New Media
 * @link       http://kogneato.com
 */


/**
 * NEEDS DOCUMENTATION
 *
 * The widget managers for the Materia package.
 *
 * @package	    Main
 * @subpackage  scoring
 * @category    Modules
  * @author      ADD NAME HERE
 */
namespace Materia;

class Score_Modules_PrivilegeWalk extends Score_Module
{

	public function check_answer($log)
	{
		error_log("\n\n\n\nchecking check_answer\n\n\na");
		return 1;
	}

}