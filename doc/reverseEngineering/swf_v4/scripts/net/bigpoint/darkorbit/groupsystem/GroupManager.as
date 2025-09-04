package net.bigpoint.darkorbit.groupsystem
{
   import com.bigpoint.utils.BPLocale;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.InvitationClip;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class GroupManager
   {
      
      private static const MEMBER_INIT_PARAM_COUNT:int = 19;
      
      private static const MEMBER_CONDENSED_INIT_PARAM_COUNT:int = 3;
      
      private var main:Main;
      
      private var _group:Group;
      
      private var _invitationErrorHashmap:Dictionary;
      
      private var markerID:int = 1000;
      
      private var _invitationsBlocked:Boolean;
      
      public function GroupManager(param1:Main)
      {
         super();
         this.main = param1;
         param1.getGuiManager().createGroupWindow();
         this.initInvitationErrorHashmap();
      }
      
      public function deleteAllInvitations() : void
      {
         var _loc2_:Invitation = null;
         var _loc1_:Array = this.main.getGuiManager().getGroupUI().invitations;
         for each(_loc2_ in _loc1_)
         {
            this.deleteInvitation(_loc2_.getInviter().id,_loc2_.getCandidate().id);
         }
      }
      
      public function isGroupMember(param1:int) : Boolean
      {
         if(this._group == null || this._group.members.length == 0)
         {
            return false;
         }
         return this.main.getGuiManager().getGroupUI().isGroupMember(param1);
      }
      
      public function changeBlockInvitationsState(param1:Boolean) : void
      {
         if(this._invitationsBlocked != param1 || this.main.getGuiManager().getGroupUI().disposed)
         {
            this._invitationsBlocked = param1;
            this.main.getGuiManager().getGroupUI().changeBlockInvitationsState(this._invitationsBlocked);
         }
      }
      
      public function init() : void
      {
      }
      
      public function handleLeaderChange(param1:int) : void
      {
         var _loc2_:GroupMember = null;
         if(!this.isInGroup())
         {
            return;
         }
         for each(_loc2_ in this._group.members)
         {
            _loc2_.isLead = _loc2_.id == param1;
         }
         this._group.heroIsBoss = param1 == Hero.userID;
         this.main.getGuiManager().getGroupUI().update();
      }
      
      private function initInvitationErrorHashmap() : void
      {
         this._invitationErrorHashmap = new Dictionary();
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_GROUP_FULL] = "msg_grp_inv_err_group_full";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_CANDIDATE_IN_GROUP] = "msg_grp_inv_err_candidate_in_group";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_CANDIDATE_NOT_AVAILABLE] = "msg_grp_inv_err_candidate_not_available";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_CANDIDATE_NON_EXISTANT] = "msg_grp_inv_err_candidate_nonexistant";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_INVITER_NONEXISTENT] = "msg_grp_inv_err_inviter_nonexistant";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_NO_INVITATION] = "msg_grp_inv_err_no_invitation";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_BOSS_ONLY] = "msg_grp_inv_err_boss_only";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_MAX_INVITATIONS_INVITER] = "msg_grp_inv_err_max_invitations_inviter";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_MAX_INVITATIONS_CANDIDATE] = "msg_grp_inv_err_max_invitations_candidate";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_BLOCKED] = "msg_grp_inv_err_candidate_blocking";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_SPAM] = "msg_grp_inv_err_spam";
         this._invitationErrorHashmap[ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ERROR_DUPLICATE] = "msg_grp_inv_err_duplicate_invitation";
      }
      
      public function handleInvitationBehaviourChange(param1:int) : void
      {
         if(this._group != null)
         {
            if(this._group.invitationBehavior != param1)
            {
               this._group.invitationBehavior = param1;
               this.main.getGuiManager().getGroupUI().update();
            }
         }
      }
      
      public function handleInvitationError(param1:String) : void
      {
         this.main.getGuiManager().writeToLog(BPLocale.getText(this._invitationErrorHashmap[param1]));
      }
      
      public function handleMemberJump(param1:int) : void
      {
      }
      
      public function handleMemberKill(param1:int) : void
      {
      }
      
      public function isInGroup() : Boolean
      {
         if(this._group != null && this._group.members.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public function cleanup() : void
      {
         this.terminateGroup();
      }
      
      public function createMapmarker(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.main.screenManager.map.getMinimapManager().getMiniMap().addMapMarker(this.markerID++,param3,param4,10);
      }
      
      public function initGroupWithMembers(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Array) : void
      {
         this.initGroup(param1,param2,param3,param4,param5);
         this.addMembersRaw(param6);
      }
      
      public function initMemberTarget(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:MapObject = null;
         var _loc6_:StubShip = null;
         var _loc2_:Array = this._group.members;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(GroupMember(_loc2_[_loc4_]).targetID == param1)
            {
               _loc5_ = this.main.screenManager.map.getShipManager().getShip(param1);
               if(_loc5_ != null)
               {
                  _loc6_ = new StubShip();
                  _loc6_.nickname = _loc5_.getUsername();
                  _loc6_.shipPatternID = _loc5_.shipPattern.getPatternID();
                  GroupMember(_loc2_[_loc4_]).targetObject = _loc6_;
                  _loc3_ = GroupMember(_loc2_[_loc4_]).id;
                  this.main.getConnectionManager().unwatchShipInit(param1);
                  break;
               }
            }
            _loc4_++;
         }
         this.main.getGuiManager().getGroupUI().update();
      }
      
      public function prepareCandidate(param1:MapObject) : void
      {
         this.main.getGuiManager().getGroupUI().setCanditate(param1);
      }
      
      public function updateMemberStats(param1:int, param2:XML) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:MapObject = null;
         var _loc7_:StubShip = null;
         var _loc3_:GroupMember = this._group.getMemberByID(param1);
         if(_loc3_ == null)
         {
            return;
         }
         if(param2.@hp.length())
         {
            _loc3_.hitPointsCurrent = int(param2.@hp);
         }
         if(param2.@hpM.length())
         {
            _loc3_.hitPointsMax = int(param2.@hpM);
         }
         if(param2.@sh.length())
         {
            _loc3_.shieldCurrent = int(param2.@sh);
         }
         if(param2.@shM.length())
         {
            _loc3_.shieldMax = int(param2.@shM);
         }
         if(param2.@pos.length())
         {
            _loc4_ = param2.@pos.toXMLString().split(",");
            _loc3_.posX = int(_loc4_[0]);
            _loc3_.posY = int(_loc4_[1]);
         }
         if(param2.@map.length())
         {
            _loc3_.mapID = int(param2.@map);
         }
         if(param2.@lev.length())
         {
            _loc3_.gameLevel = int(param2.@lev);
         }
         if(param2.@fra.length())
         {
            _loc3_.factionID = int(param2.@fra);
         }
         if(param2.@act.length())
         {
            _loc3_.activity = Boolean(int(param2.@act));
         }
         if(param2.@clk.length())
         {
            _loc3_.isCloaked = Boolean(int(param2.@clk));
         }
         if(param2.@shp.length())
         {
            _loc3_.shipType = int(param2.@shp);
         }
         if(param2.@fgt.length())
         {
            _loc3_.fightState = Boolean(int(param2.@fgt));
         }
         if(param2.@lgo.length())
         {
            _loc3_.isOffline = Boolean(int(param2.@lgo));
         }
         if(param2.@tgt.length())
         {
            _loc5_ = int(param2.@tgt);
            this.main.getConnectionManager().unwatchShipInit(_loc3_.targetID);
            _loc3_.targetID = _loc5_;
            if(_loc5_ > 0 && _loc3_.mapID == Settings.mapID)
            {
               _loc6_ = this.main.screenManager.map.getShipManager().getShip(_loc3_.targetID);
               if(_loc6_ != null)
               {
                  _loc7_ = new StubShip();
                  _loc7_.nickname = _loc6_.getUsername();
                  _loc7_.shipPatternID = _loc6_.shipPattern.getPatternID();
                  _loc3_.targetObject = _loc7_;
               }
               else if(_loc3_.mapID == Settings.mapID)
               {
                  this.main.getConnectionManager().watchShipInit(_loc5_);
               }
            }
            else
            {
               _loc3_.targetObject = null;
            }
         }
         this.main.getGuiManager().getGroupUI().update();
      }
      
      public function deleteInvitation(param1:int, param2:int, param3:String = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:Invitation = null;
         if(param1 == Hero.userID)
         {
            _loc4_ = param2;
            _loc5_ = InvitationClip.TYPE_OUTGOING;
         }
         else
         {
            _loc4_ = param1;
            _loc5_ = InvitationClip.TYPE_INCOMING;
         }
         if(param3 != null)
         {
            _loc7_ = "%name%";
            _loc8_ = "";
            _loc9_ = true;
            switch(param3)
            {
               case ServerCommands.GROUPSYSTEM_GROUP_INVITATION_DELETE_REVOKE:
                  _loc6_ = "msg_grp_inv_revoke_inviter";
                  if(_loc5_ == InvitationClip.TYPE_INCOMING)
                  {
                     _loc9_ = false;
                     for each(_loc10_ in this.main.getGuiManager().getGroupUI().receivedInvitations)
                     {
                        if(_loc10_.getInviter().id == _loc4_)
                        {
                           _loc8_ = _loc10_.getInviter().nickName;
                        }
                     }
                  }
                  break;
               case ServerCommands.GROUPSYSTEM_GROUP_INVITATION_DELETE_REJECT:
                  _loc6_ = "msg_grp_inv_invitation_rejected_candidate";
                  if(_loc5_ == InvitationClip.TYPE_OUTGOING)
                  {
                     _loc9_ = false;
                     for each(_loc10_ in this.main.getGuiManager().getGroupUI().sentInvitations)
                     {
                        if(_loc10_.getCandidate().id == _loc4_)
                        {
                           _loc8_ = _loc10_.getCandidate().nickName;
                        }
                     }
                  }
                  break;
               case ServerCommands.GROUPSYSTEM_GROUP_INVITATION_DELETE_TIMEOUT:
                  if(_loc5_ == InvitationClip.TYPE_OUTGOING)
                  {
                     _loc6_ = "msg_grp_inv_timeout_checked_inviter";
                     _loc7_ = "%invited%";
                     for each(_loc10_ in this.main.getGuiManager().getGroupUI().sentInvitations)
                     {
                        if(_loc10_.getCandidate().id == _loc4_)
                        {
                           _loc8_ = _loc10_.getCandidate().nickName;
                           _loc9_ = false;
                           break;
                        }
                     }
                  }
                  else if(_loc5_ == InvitationClip.TYPE_INCOMING)
                  {
                     _loc6_ = "msg_grp_inv_timeout_checked_candidate";
                     _loc7_ = "%inviter%";
                     for each(_loc10_ in this.main.getGuiManager().getGroupUI().receivedInvitations)
                     {
                        if(_loc10_.getInviter().id == _loc4_)
                        {
                           _loc8_ = _loc10_.getInviter().nickName;
                           _loc9_ = false;
                           break;
                        }
                     }
                  }
            }
            if(!_loc9_)
            {
               this.main.getGuiManager().writeToLog(BPLocale.getText(_loc6_).replace(_loc7_,_loc8_));
            }
         }
         this.main.getGuiManager().getGroupUI().removeInvitation(_loc4_,_loc5_);
         this.main.getGuiManager().getGroupUI().update();
      }
      
      public function onMemberLeft(param1:int, param2:String) : void
      {
         var _loc3_:GroupMember = null;
         var _loc4_:String = null;
         if(param1 != Hero.userID)
         {
            _loc3_ = this._group.getMemberByID(param1);
            switch(param2)
            {
               case ServerCommands.GROUPSYSTEM_GROUP_EVENT_MEMBER_LEAVES_SUB_KICK:
                  _loc4_ = "msg_grp_leave_group_reason_kick";
                  break;
               case ServerCommands.GROUPSYSTEM_GROUP_EVENT_MEMBER_LEAVES_SUB_LEAVE:
                  _loc4_ = "msg_grp_leave_group_reason_leave";
                  break;
               case ServerCommands.GROUPSYSTEM_GROUP_EVENT_MEMBER_LEAVES_SUB_NONE:
                  _loc4_ = "msg_grp_leave_group_reason_none";
            }
            this.main.getGuiManager().writeToLog(BPLocale.getText(_loc4_).replace(/%name%/,_loc3_.nickName));
            this.removeMemberByID(param1);
            this.main.getGuiManager().getGroupUI().update();
         }
         else
         {
            this.terminateGroup();
         }
      }
      
      public function terminateGroup(param1:Boolean = true) : void
      {
         var _loc2_:GroupMember = null;
         var _loc3_:MovieClip = null;
         if(this._group)
         {
            for each(_loc2_ in this._group.members)
            {
               if(_loc2_.id != Hero.userID)
               {
                  this.changeShipGroupState(_loc2_.id,false);
               }
            }
            _loc3_ = this.main.getGuiManager().getGlobalchat();
            if(_loc3_ != null && param1)
            {
               _loc3_.leaveGroupRoom();
            }
         }
         this._group = new Group();
         this._group = null;
         this.main.getGuiManager().getGroupUI().setGroup(this._group);
         this.main.getGuiManager().getGroupUI().update();
      }
      
      private function initGroup(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.terminateGroup(false);
         this._group = new Group();
         this._group.init(param1,param2,param3,param4,param5);
         this.joinGroupChat();
         this.main.getGuiManager().getGroupUI().setGroup(this._group);
         this.main.getGuiManager().getGroupUI().update();
      }
      
      private function addMembersRaw(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc4_:GroupMember = null;
         var _loc3_:int = 1;
         while(param1.length >= MEMBER_INIT_PARAM_COUNT)
         {
            _loc2_ = param1.splice(0,MEMBER_INIT_PARAM_COUNT);
            _loc4_ = this.parseMember(_loc2_);
            _loc4_.orderID = _loc3_;
            if(_loc3_ == 1)
            {
               _loc4_.isLead = true;
            }
            _loc3_++;
            this.addMember(_loc4_);
         }
         this._group.heroIsBoss = GroupMember(this._group.members[0]).id == Hero.userID;
         this.main.getGuiManager().getGroupUI().update();
      }
      
      public function parseMember(param1:Array) : GroupMember
      {
         var _loc21_:MapObject = null;
         var _loc22_:StubShip = null;
         var _loc2_:String = param1.shift();
         var _loc3_:int = int(param1.shift());
         var _loc4_:int = int(param1.shift());
         var _loc5_:int = int(param1.shift());
         var _loc6_:int = int(param1.shift());
         var _loc7_:int = int(param1.shift());
         var _loc8_:int = int(param1.shift());
         var _loc9_:int = int(param1.shift());
         var _loc10_:int = int(param1.shift());
         var _loc11_:int = int(param1.shift());
         var _loc12_:Boolean = Boolean(int(param1.shift()));
         var _loc13_:Boolean = Boolean(int(param1.shift()));
         var _loc14_:Boolean = Boolean(int(param1.shift()));
         var _loc15_:int = int(param1.shift());
         var _loc16_:int = int(param1.shift());
         var _loc17_:String = param1.shift();
         var _loc18_:int = int(param1.shift());
         var _loc19_:Boolean = Boolean(int(param1.shift()));
         var _loc20_:GroupMember = new GroupMember();
         _loc20_.init(_loc3_,_loc2_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_);
         if(_loc16_ != -1)
         {
            _loc21_ = this.main.screenManager.map.getShipManager().getShip(_loc16_);
            if(_loc21_ != null)
            {
               _loc22_ = new StubShip();
               _loc22_.nickname = _loc21_.getUsername();
               _loc22_.shipPatternID = _loc21_.shipPattern.getPatternID();
               _loc20_.targetObject = _loc22_;
            }
            else if(_loc8_ == Settings.mapID)
            {
               this.main.getConnectionManager().watchShipInit(_loc16_);
               this.main.getConnectionManager().sendCommand(ClientCommands.FORCE_INIT,[_loc16_]);
            }
         }
         return _loc20_;
      }
      
      public function handleRawInvitation(param1:Array) : void
      {
         var _loc2_:Invitation = new Invitation();
         var _loc3_:GroupMember = this.parseCondensedMember(param1.splice(0,MEMBER_CONDENSED_INIT_PARAM_COUNT));
         var _loc4_:GroupMember = this.parseCondensedMember(param1);
         _loc2_.setInviter(_loc3_);
         _loc2_.setCandidate(_loc4_);
         if(_loc3_.id != Hero.userID && _loc4_.id != Hero.userID)
         {
            this.main.getGuiManager().writeToLog(BPLocale.getText("msg_grp_inv_info_from_to").replace(/%inviter%/,_loc3_.nickName).replace(/%candidate%/,_loc4_.nickName));
         }
         else
         {
            this.main.getGuiManager().getGroupUI().addInvitation(_loc2_);
            this.main.getGuiManager().getGroupUI().update();
         }
      }
      
      private function parseCondensedMember(param1:Array) : GroupMember
      {
         var _loc2_:int = int(param1.shift());
         var _loc3_:String = param1.shift();
         var _loc4_:int = int(param1.shift());
         var _loc5_:GroupMember = new GroupMember();
         _loc5_.init(_loc2_,_loc3_);
         _loc5_.shipType = _loc4_;
         return _loc5_;
      }
      
      public function addMember(param1:GroupMember) : void
      {
         this._group.addMember(param1);
         this.changeShipGroupState(param1.id,true);
      }
      
      public function removeMemberByID(param1:int) : void
      {
         this._group.removeMember(param1);
         if(param1 != Hero.userID)
         {
            this.main.getGuiManager().getGroupUI().removeMemberClip(param1);
         }
         this.changeShipGroupState(param1,false);
      }
      
      public function removeMember(param1:GroupMember) : void
      {
         this.removeMemberByID(param1.id);
      }
      
      public function changeShipGroupState(param1:int, param2:Boolean) : void
      {
         var _loc3_:MapObject = this.main.screenManager.map.getShipManager().getShip(param1);
         if(_loc3_)
         {
            _loc3_.isGroupMember = param2;
            _loc3_.updateLabel();
         }
      }
      
      public function handleGroupError(param1:String, param2:int) : void
      {
         switch(param1)
         {
            case ServerCommands.GROUPSYSTEM_GROUP_EVENT_ERROR_SUB_ATTACK:
               this.main.getGuiManager().writeToLog(BPLocale.getText("msg_grp_attack_impossible"));
               break;
            case ServerCommands.GROUPSYSTEM_GROUP_EVENT_ERROR_SUB_FOLLOW:
            case ServerCommands.GROUPSYSTEM_GROUP_EVENT_ERROR_SUB_PING:
               this.main.getGuiManager().writeToLog(BPLocale.getText("label_grp_follow_impossible"));
         }
      }
      
      public function dispose() : void
      {
         this.main.getGuiManager().getGroupUI().dispose();
      }
      
      public function joinGroupChat() : void
      {
         var _loc1_:MovieClip = null;
         if(this.main.getGuiManager().isChatConnected)
         {
            _loc1_ = this.main.getGuiManager().getGlobalchat();
            if(_loc1_ != null && this._group != null)
            {
               _loc1_.createGroupRoom(this._group.id,BPLocale.getText("title_group"));
            }
         }
      }
   }
}

