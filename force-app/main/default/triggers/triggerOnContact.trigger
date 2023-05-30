

    trigger triggerOnContact on Contact ( before insert) {
        system.debug('entered trigegr');
    TriggerFactory.initiateHandler(Contact.sObjectType);
    }

