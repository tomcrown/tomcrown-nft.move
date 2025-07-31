module tomcrown_nft::tomcrown_nft;

use std::string::{Self, String, utf8};
use sui::url::{Self, Url};
use sui::event;
use sui::package;
use sui::display;


public struct TomNFT has key, store {
    id: UID,
    name: String,
    description: String,
    image_url: Url,
}

public struct TOMCROWN_NFT has drop{}

public struct NFTMinted has copy, drop {
    name: String,
    description: String,
    image_url: Url,
}


fun init(otw: TOMCROWN_NFT, ctx: &mut TxContext) {
    let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url"),
        ];
 
        let values = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url"),
 
        ];
 
        let publisher = package::claim(otw, ctx);
 
        let mut display = display::new_with_fields<TomNFT> (
            &publisher, keys, values, ctx
        );

        display.update_version();
 
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
}


#[allow(lint(self_transfer))]
public entry fun mint_to_sender( 
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    ctx: &mut TxContext,
) {
    let sender = ctx.sender();
    let nft = TomNFT {
        id: object::new(ctx),
        name: utf8(name),
        description: utf8(description),
        image_url: url::new_unsafe_from_bytes(url),
    };
 
    event::emit(NFTMinted {
        name: nft.name,
        description: nft.description,
        image_url: nft.image_url,
    });
 
    transfer::public_transfer(nft, sender);
}
