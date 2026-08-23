{ ... }:

{
  programs.nixvim =
    let
      caos_dir = "~/cloud/l1-cache/caos";
    in
    {
    plugins.orgmode = {
      enable = true;

      settings = {
        org_agenda_files = [
          "${caos_dir}/projects/active/*"
          "${caos_dir}/capture.org"
        ];
        org_default_notes_file = "${caos_dir}/capture.org";

        org_todo_keywords = [ "TODO" "|" "DONE" "CANC" ];
        org_deadline_warning_days = 1;

        org_capture_templates = {
          c = {
            description = "Capture Thoughts";
            template = "* %?";
          };
          i = {
            description = "Task Idea";
            template = "* %? :IDEA:";
          };
          t = {
            description = "Task";
            template = "* TODO %? :IDEA: \n  SCHEDULED: %^t";
          };
        };

        org_agenda_skip_scheduled_if_done = true;
        org_agenda_skip_deadline_if_done = true;

        org_agenda_custom_commands = {
          c = {
            description = "Theo's [C]ustom Personal agenda + IDEA (captured tasks)";
            types = [
              {
                type = "tags";
                match = "IDEA";
                org_agenda_overriding_header = "IDEA (tasks & task ideas in ~capture.org~)";
              }
              {
                type = "agenda";
              }
            ];
          };
        };

        # Keymaps from Emacs org-mode
        mappings = {
          agenda = {
            org_agenda_later = [ "f" "]" ];
            org_agenda_earlier = [ "b" "[" ];
            org_agenda_todo = [ "<S-RIGHT>" ]; # Removed the default `t`
          };
          capture = {
            org_capture_finalize = [ "<C-c>" "<C-c><C-c>" ];
            org_capture_kill = [ "<prefix>k" "<C-c><C-k>" ];
          };
          org = {
            org_priority = [ "<C-c>," "<prefix>," ];
            org_priority_up = [ "ciR" "<S-UP>" ];
            org_priority_down = [ "cir" "<S-DOWN>" ];
            org_todo = [ "cit" "<S-RIGHT>" ];
            org_todo_prev = [ "ciT" "<S-LEFT>" ];
            org_insert_todo_heading_respect_content = [ "<prefix>it" "<C-CR>" ];
            org_deadline = [ "<prefix>id" "<C-c><C-d>" ];
            org_schedule = [ "<prefix>is" "<C-c><C-s>" ];
          };
        };
      };
    };

    userCommands = {
      CdOrg = {
        command = "lcd ${caos_dir}";
        desc = "lcd into Org directory";
      };
    };
  };
}
