import com.mongodb.client.MongoClients
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.mongodb.MongoDatabaseFactory
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory
import org.springframework.data.mongodb.core.mapping.MongoMappingContext
import org.springframework.data.mongodb.core.convert.MappingMongoConverter
import org.springframework.data.mongodb.core.convert.MongoCustomConversions
import org.springframework.data.mongodb.core.convert.DbRefResolver
import org.springframework.data.mongodb.core.convert.DefaultDbRefResolver
import org.springframework.data.mongodb.core.convert.DefaultMongoTypeMapper
import org.springframework.data.mongodb.core.convert.MongoCustomConversions
import org.springframework.data.mongodb.core.mapping.event.ValidatingMongoEventListener
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean

@Configuration
class MongoConfig {
    
    @Bean
    MongoDatabaseFactory mongoDatabaseFactory() {
        def mongoClient = MongoClients.create("mongodb://localhost:27017/construyesmart")
        return new SimpleMongoClientDatabaseFactory(mongoClient, "construyesmart")
    }
    
    @Bean
    MongoMappingContext mongoMappingContext() {
        def context = new MongoMappingContext()
        context.setAutoIndexCreation(true)
        return context
    }
    
    @Bean
    MongoCustomConversions mongoCustomConversions() {
        return new MongoCustomConversions([])
    }
    
    @Bean
    MappingMongoConverter mappingMongoConverter(MongoDatabaseFactory factory, MongoMappingContext context, MongoCustomConversions conversions) {
        DbRefResolver dbRefResolver = new DefaultDbRefResolver(factory)
        MappingMongoConverter converter = new MappingMongoConverter(dbRefResolver, context)
        converter.setCustomConversions(conversions)
        converter.setTypeMapper(new DefaultMongoTypeMapper(null))
        return converter
    }
    
    @Bean
    MongoTemplate mongoTemplate(MongoDatabaseFactory factory, MappingMongoConverter converter) {
        return new MongoTemplate(factory, converter)
    }

    @Bean
    ValidatingMongoEventListener validatingMongoEventListener() {
        return new ValidatingMongoEventListener(validator())
    }

    @Bean
    LocalValidatorFactoryBean validator() {
        return new LocalValidatorFactoryBean()
    }
} 