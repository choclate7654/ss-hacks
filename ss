stance = distance;
                        nearestPlayer.player = them;
                    }
                }
            }
        }
    })
    if(nearestPlayer.player){
        return nearestPlayer;
    }
    return null;
}

window.calcAngle = function(us, them, dist){
    let delta = {x: t
    let delta = {x: them.x - us.x ,
                 y: them.y-us.y - 0.072,
                 z: them.z - us.z,
                };

    delta = new BABYLON.Vector3(delta.x, delta.y, delta.z).normalize();
    const newYaw = Math.radRange(-Math.atan2(delta.z, delta.x) + Math.PI / 2)

    const newPitch = Math.clamp(-Math.asin(delta.y), -1.5, 1.5);


    return {pitch: newPitch || 0, yaw: newYaw || 0};
}




window.otherPlayer;
window.myPlayer;

window.espColourSettings = function(that){
    if(that.player.team==1){
        that.bodyMesh.overlayColor = hexToRgb(window.settings.blueTeam);
    }else if(that.player.team==2){
        that.bodyMesh.overlayColor = hexToRgb(window.settings.redTeam);
    }else{
        that.bodyMesh.overlayColor = hexToRgb(window.settings.orangeTeam);
    }
    that.bodyMesh.setRenderingGroupId(1);
}

window.doAimbot = (ourPlayer,otherPlayers)=>{

    if(!window.aimbotToggled){return};
    if(!window.myPlayer){
        otherPlayers.forEach(player=>{
            if(player){
                if(player.ws){
                    window.myPlayer = player;
                }}
        })
    };
    //loop through other palyers
    let nearest = window.getNearestPlayer(ourPlayer, otherPlayers);
    if(nearest){
        //console.log(nearest.name);
        calcAngle(window.myPlayer, nearest.player, nearest.distance)
    }

};
window.visiblePlayers = {};


Object.defineProperty(window, "uuid", {get: ()=>{return 0}});



const request = url => fetch(url).then(res => res.text());
const injectInline = (data) => {
    let s = document.createElement('script');
    s.type = 'text/javascript';
    s.innerText = data;
    document.getElementsByTagName('head')[0].appendChild(s);
}


window.hexToRgb =(hex)=>{
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16)/255,
        g: parseInt(result[2], 16)/255,
        b: parseInt(result[3], 16)/255,
        a: 1,
    } : null;
}

const attemptPatch = (source) => {
    const patches = new Map()


    
    .set("RENDERHOOK", [/var (\w+)=([a-zA-Z$]+)\(this\.mesh,\.(\d+)\);/, "rep = `var ${match[1]} = ${match[2]}(this.mesh,.31);window.visiblePlayers[this.player.id]=${match[1]};${match[1]}=true;this.bodyMesh.renderOverlay = !0;window.espColourSettings(this);`", true])
    .set("PLAYERHOOK", [/if\([^(\/.,)]+\)([^(\/.,)]+)\.actor\.update\([^(\/.,)]+\);/, false])
    .set("ENEMYHOOK", [/var [^(\/.,=]+\=([^(\/.,\[\]]+)\[[^(\/.,\[\]]\];[^(\/.,=&]+\&\&\([^(\/.,=]+\.chatLineCap/, false])
    .set("AIMBOTHOOK", [/[^(\/.,]+\([^(\/.,]+,[^(\/.,]+\/\d+\),[^(\/.,]+\.runRenderLoop\(\(function\(\)\{/, "rep = `${match[0]}window.doAimbot(${variables.PLAYERHOOK[1]}, ${variables.ENEMYHOOK[1]});`", true])

    variables = {};

    for (const [name, item] of patches) {
        let match = source.match(item[0]);

        if(!item[1]){
            if(match){
                variables[name] = match;
            }else{
                alert(`Failed to variable ${name}`);
                continue;
            }
        }else{
            let rep;
            try{
                eval(item[1]);
            }catch(e){
                alert(`Failed to patch ${name}`);
                continue;
            }
            console.log(rep);

            const patched = source.replace(item[0], rep);
            if (source === patched) {
                alert(`Failed to patch ${name}`);
                continue;
            } else console.log("Successfully patched ", name);
            source = patched;
        }
    }
