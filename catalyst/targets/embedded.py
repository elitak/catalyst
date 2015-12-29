"""
Enbedded target, similar to the stage2 target, builds upon a stage2 tarball.

A stage2 tarball is unpacked, but instead
of building a stage3, it emerges @system into another directory
inside the stage2 system.  This way, we do not have to emerge GCC/portage
into the staged system.
It may sound complicated but basically it runs
ROOT=/tmp/submerge emerge --something foo bar .
"""
# NOTE: That^^ docstring has influence catalyst-spec(5) man page generation.

from catalyst import log
from catalyst.support import normpath
from catalyst.base.stagebase import StageBase

class embedded(StageBase):
	"""
	Builder class for embedded target
	"""
	def __init__(self,spec,addlargs):
		self.required_values=[]
		self.valid_values=[]
		self.valid_values.extend(["embedded/empty",
                                          "embedded/rm",
                                          "embedded/unmerge",
                                          "embedded/fs-prepare",
                                          "embedded/fs-finish",
                                          "embedded/mergeroot",
                                          "embedded/packages",
                                          "embedded/fs-type",
                                          "embedded/runscript",
                                          "boot/kernel",
                                          "embedded/linuxrc",
                                          "embedded/use",
                                          "embedded/fsscript",
                                          "install_mask",
                                          "myfeatures"])

		if "embedded/fs-type" in addlargs:
			self.valid_values.append("embedded/fs-ops")
		if "embedded/mergeroot" not in addlargs:
			addlargs["embedded/mergeroot"] = "/tmp/mergeroot"

		StageBase.__init__(self,spec,addlargs)
		self.set_build_kernel_vars()

	def set_action_sequence(self):
		self.settings["action_sequence"]=["unpack","unpack_snapshot",\
					"config_profile_link","setup_confdir",\
					"portage_overlay","bind","chroot_setup",\
					"setup_environment","build_kernel","build_packages",\
					"bootloader","root_overlay","fsscript","unmerge",\
					"unbind","remove","empty","clean","capture","clear_autoresume"]

	def set_stage_path(self):
		self.settings["stage_path"]=normpath(self.settings["chroot_path"]+self.settings["mergeroot"])
		log.info('embedded stage path is %s', self.settings['stage_path'])

	def set_root_path(self):
		self.settings["root_path"]=normpath(self.settings["mergeroot"])
		log.info('embedded root path is %s', self.settings['root_path'])
