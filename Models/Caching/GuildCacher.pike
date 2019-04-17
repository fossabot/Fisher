/**
* Used to help with guild caching related traffic
* - Members
* - Channels
* - Presences
* - Emojis
* - Roles
*/
class GuildCacher {
  Client client;

  void create(Client c) {
    client = c;
  }

  void cacheMembers(Guild guild, array data) {
    foreach(data, mixed member) {
      array roles = member.roles;
      member.user = User(client, member.user);

      member = GuildMember(client, guild, member);

        // Cach roles
      foreach(roles, string key) {
        member.roles->assign(key, guild.roles->get(key));
      }

      guild.members->assign(member.user.id, member);
      client.cacher->cacheUser(member.user);
    }
  }

  void cacheChannels(Guild guild, array data) {
    foreach(data, mixed channel) {
      switch(channel.type) {
        case 0:
          guild.channels->assign(channel.id, GuildTextChannel(client, guild, channel));
          client.cacher->cacheChannel(channel, GuildTextChannel);
          break;
        case 2:
          guild.channels->assign(channel.id, ChannelVoice(client, channel));
          client.cacher->cacheChannel(channel, ChannelVoice);
          break;
        case 4:
          guild.channels->assign(channel.id, ChannelCategory(client, channel));
          client.cacher->cacheChannel(channel, ChannelCategory);
          break;
      }

    }
  }

  void cacheRoles(Guild guild, array data) {
    foreach(data, mixed role) {
      guild.roles->assign(role.id, Role(client, guild, role));
    }
  }

  void cacheEmojis(Guild guild, array data) {
    foreach(data, mixed emoji) {
      guild.emojis->assign(emoji.id, Emoji(client, guild, emoji));
      client.cacher->cacheEmoji(guild, emoji);
    }
  }
}
